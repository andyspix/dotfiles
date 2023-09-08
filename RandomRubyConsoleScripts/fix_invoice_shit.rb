all_invoices = IntacctConfiguration.joins(:account).where('accounts.account_state': 'active').where.not(netsuite_id: nil).map do |ic|
  [ic.account.account_number_name, ic.fetch_invoice_data(Date.today.days_ago(8)..Date.today, skip_line_items: false).sort_by { |x| -x[:recordid].to_i }]
end.to_h

tmp_yaml all_invoices

recordid_map = all_invoices.reject { |k, v| v.count == 0 }.map { |k,v| [k, v.map { |i| i[:recordid] }.sort.join('!')] }.to_h
fixit = read_csv "/Users/andyspix/Desktop/annotated_int_feb.csv"
fixit.each { |r| r['IntacctRecordid'] = recordid_map[r['PwsAccountNumberName']] }

tmp_csv [*fixit]

# this mostly assigns invoice numbers to lines in the csv to create a map to post invoices to netsuite from,
# need to cleanup any lines with exclamation points (!) by choosing the right invoice for that customer.
# No easy way around that due to many-to-many account/config maps and flattened csv, faster to do it by hand
# in google sheets (DONT USE EXCEL!!!).
#

# Load 'em up:
# csv = read_csv '/Users/andyspix/Desktop/annotated_int_dec_fixed.csv'
# csv = read_csv '/Users/andyspix/Desktop/annotated_int_jan_fixed.csv'
csv = read_csv '/Users/andyspix/Desktop/annotated_int_feb_fixed.csv'

nah = NetsuiteApiHandler.new
ns_terms = nah.get_term.pluck('name', 'id').to_h
ns_items = nah.get_item
               .select { |x| x['itemid'] =~ /^PWS CaaS/ }
               .pluck('displayname', 'class', 'id')
               .map { |x, y, z| [[x, y['text'].split(' : ').second], z] }.to_h

data = {}
csv.each do |row|
  data[row['PwsAccountNumberName']] = {
    customform:          { id: Rails.application.secrets.netsuite[:customform] },
    entity:              { id: row['NetsuiteID'] },
    terms:               { id: ns_terms[row['Terms']] },
    otherrefnum:         row['CustomerReference'],
    custbody_refnum_pws: row['ReferenceNumber'],
    memo:                'Connectivity and Services',
    custbody_pws_intaact_record_id:   row['IntacctRecordid'],
    approvalstatus:      { id: 2 },
    trandate:            { type: 'date', id: Date.parse(row['DateCreated']).to_formatted_s(:netsuite_invoice) },
    duedate:             { type: 'date', id: Date.parse(row['DateDue']).to_formatted_s(:netsuite_invoice) },
    items:               []
  }.reject { |_k, v| v == '' }
end
# Read the rows again to populate the line items:
csv.each do |row| # rubocop:disable Style/CombinableLoops
  lineitem = {
    item:                { id: ns_items[[row['NetsuiteItem'], row['Class']]] },
    quantity:            row['Quantity'],
    rate:                row['Rate'],
    amount:              row['Amount'],
    custcol_memo_pws:    row['Memo'],
    custcol_element_pws: row['Element']
  }
  data[row['PwsAccountNumberName']][:items].append(lineitem)
end

def mark_as_posted(acct, invoice)
  ac_id = Account.find_by(account_number: acct.split(':').first)&.id
  total = invoice[:items].pluck(:amount).map(&:to_f).sum.round(2)
  ih = InvoiceHistory.find_or_create_by(date_posted: date_posted_from_netsuite(invoice), account_number_name: acct, account_id: ac_id, total_due: total)
  ih.update netsuite: true
end

handler = NetsuiteApiHandler.new
okay = []
data.each do |acct, invoice|
  result = handler.post_invoice({ data: [invoice] })
  if result.respond_to?(:match?) && result.match?(/Invoices created: \[\d\d+\]/)
    okay << [acct, invoice]
  end
end

success = okay.map { |x| x[0] }
fails = data.keys - success

retrys = {}
fails.each { |f| retrys[f] = data[f] }
