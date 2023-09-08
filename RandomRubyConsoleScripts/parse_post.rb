nah = NetsuiteApiHandler.new
@ns_terms = nah.get_term.pluck('name', 'id').to_h
@ns_items = nah.get_item.select { |x| x['itemid'] =~ /^PWS CaaS/ }.pluck('displayname', 'id').to_h
@ns_cas = {
  'ATT_100374402_PN--ATT Private'                 => 1,
  'VZW_645_778_PN--Verizon Private'               => 2,
  'VZW_742071985_DIA--Verizon DIA'                => 3,
  'VZW_742006538_PUB--Verizon Public'             => 4,
  'VDF_1000032186_PN--Vodafone Private'           => 5,
  'TMO_BAN0001_PN--T-Mobile Private'              => 6,
  'TMD_500417240_TMobile Direct--T-Mobile Direct' => 7,
  'SWN_431915313_PN--SW Private'                  => 8,
  'TLS_100213113--Telus Private'                  => 9,
  'WLO_117949--Wireless Logic'                    => 10,
  'PWS_5774886D_PN--Premier Wireless Private'     => 11
}


@csv_file = File.open('/Users/andyspix/Desktop/test_upload_ns.csv', 'r')
@clean_rows = []
@errors = []

@csv_file.each_line.with_index do |line, index|
  CSV.parse_line(line, encoding: 'utf-8') ? @clean_rows << line : @errors << ["Parse Error: row #{index + 1}", line]
end

@clean_rows.last.gsub!(/\n$/, "\r\n") if @clean_rows.last =~ /[^\r]\n$/ && @clean_rows.first =~ /\r\n$/

data = {}
csv = CSV.parse(@clean_rows.join, headers: true, encoding: 'utf-8')
csv.each do |row|
  data[row['PwsAccountNumberName']] = {
    customform:  { id: 304 },
    entity:      { id: row['NetsuiteID'] },
    otherrefnum: row['CustomerReference'],
    custbody_refunm_pws: row['ReferenceNumber'],
    trandate:    { type: 'date', id: Date.parse(row['DateCreated']).to_formatted_s(:intacct_invoice) },
    duedate:     { type: 'date', id: Date.parse(row['DateDue']).to_formatted_s(:intacct_invoice) },
    terms:       { id: @ns_terms[row['Terms']] },
    items:   []
  }.reject { |k, v| v == '' }
end
# Read the rows again to populate the line items:
csv.each do |row| # rubocop:disable Style/CombinableLoops
  lineitem = {
    item:               { id: @ns_items[row['NetsuiteItem']] },
    quantity:           row['Quantity'],
    rate:               row['Rate'],
    custcolmemo_pws:    row['Memo'],
    custcolelement_pws: row['Element']
  }
  lineitem[:custcolcarrier_account_pws] = { id: @ns_cas[row['Class']] } unless @ns_cas[row['Class']].nil?
  data[row['PwsAccountNumberName']][:items].append(lineitem)
end

#nah.post_invoice({ data: [data[data.keys.first]] })

errors = []
success = []
data.each do |acct, invoice|
  result = nah.post_invoice({ data: [invoice] })
  if result.match?(/Invoices created: \[\d\d+\]/)
    success << acct
  else
    errors << { descriptions: result, data: { acct => invoice } }
  end
rescue StandardError => e
  errors << { descriptions: "#{acct} :: #{e}", data: { acct => invoice } }
end




