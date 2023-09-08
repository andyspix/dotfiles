# Everything from the batch posting
handler = IntacctApiHandler.new
handler.establish_session('PWS2')
resp = handler.get_object_by_query('ARINVOICE', 'PRBATCH = \'Invoices - PWS2: 2022/02/28 Batch\'', pagesize: 1000)

# Get the invoices and extract the data
res = resp.first.parsed.xpath('//arinvoice').map { |xp| Hash.from_xml xp.to_xml }
res2 = res.map { |x| x['arinvoice'] }
res3 = res2.pluck('CUSTOMERID', 'CUSTOMERNAME', 'RECORDID', 'RECORDNO', 'STATE').group_by {|x,y,z,w, q| x}
# Sanity check the returns:
ap res3

# Grab the record numbers
ids = res2.pluck('RECORDNO')

# revert
responses = []
(record_ids.map(&:to_i) - [114834]).each do |recordno|
  date = Date.today.months_ago(1).end_of_month
  control = Time.now.to_i
  xml = handler.reverse_invoice_xml(control, recordno, date)
  responses << handler.post_xml(xml, control)
end

