csv = read_csv '/tmp/3g_devs.csv'
csv.each do |r|
  d = Device.find_by(mdn: r['MDN'])
  rp = d.rate_plan
  r['Device name'] = "#{d.device_name}\t"
  r['MRC allowance'] = rp.mrc_data
  r['Price MRC'] = rp.price_mrc_data
end

CSV.open("/tmp/annotated_3g_devs.csv", "w") do |f|
  f << csv.headers
  csv.each{|row| f << row}
end


