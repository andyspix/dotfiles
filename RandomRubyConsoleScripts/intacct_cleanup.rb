csv = read_csv '/Users/andyspix/Desktop/fixed_customers.csv'

handler ||= IntacctApiHandler.new
handler.establish_session

results = csv.map do |row|
  xml = handler.update_customer_xml(
    Time.now.to_i,
    row['Customer ID'],
    attn:    row['Attention'].to_s,
    addr1:   row['Address line 1'].to_s,
    addr2:   row['Address line 2'].to_s,
    city:    row['City'].to_s,
    state:   row['State/Territory'].to_s,
    zip:     row['Zip code/Post code'].to_s,
    country: row['Country'].to_s,
    phone1:  row['Phone number'].to_s,
    cellphone:  row['Mobile phone'].to_s
  )
  resp = handler.post_xml(xml)
  resp.errors.empty? ? nil : [row['Customer ID'], resp]
end.compact

### ROUND2 - Jul 7, 2022
# Shipping Method changes
resp2 = handler.get_object_by_query('CUSTOMER', "DISPLAYCONTACT.PREFIX like %", pagesize: 100)
resp = handler.get_object_by_query('CUSTOMER', "NAME like %", 'NAME, DISPLAYCONTACT.PREFIX' pagesize: 100)
field_hash = Hash.new(0)
need_fixes = resp2.each do |x|
  x.parsed.xpath('//data').first.children.each do |y|
    y.elements.each do |e|
      next if e.inner_text.blank?
      field_hash[e.name] += 1
    end
  end
end

csv2 = read_csv '/Users/andyspix/Desktop/fixed_shipping.csv'

results = []
csv2.each do |row|
  xml = handler.update_customer_xml(
    Time.now.to_i,
    row['Customer ID'],
    pager:            row['pager'].to_s,
  )
  resp = handler.post_xml(xml)
  results << (resp.errors.empty? ? nil : [row['Customer ID'], resp])
end

### ROUND3 - Jul 7, 2022
# Email Field cleanups

resp = handler.get_object_by_query('CUSTOMER', "DISPLAYCONTACT.EMAIL2 like '%,%'", 'CUSTOMERID, DISPLAYCONTACT.EMAIL2', pagesize: 100)
need_fixes = resp.map {|x| x.parsed.xpath('//data').first.children.map { |x| x.elements.map(&:inner_text) } }.flatten(1)
fix_ary = need_fixes.map { |y| [y[0], y[1].gsub(',', '; ')] }

results3 = []
fix_ary.each do |y|
  xml = handler.update_customer_email_xml( Time.now.to_i, y[0], email2: y[1])
  resp = handler.post_xml(xml)
  results3 << (resp.errors.empty? ? nil : [row['Customer ID'], resp])
end
