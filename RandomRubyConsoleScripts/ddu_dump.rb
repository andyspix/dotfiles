(Date.parse('2021-01-01')..Date.parse('2021-09-01')).select { |d| d.day == 1 }.each do |month|
  res = Device.joins(:daily_data_usages, :carrier).where('daily_data_usages.date_for': month.beginning_of_month..month.end_of_month).where.not('daily_data_usages.bytes_used': 0).pluck('carriers.carrier_name', 'devices.device_name', 'daily_data_usages.date_for', 'daily_data_usages.bytes_used'); 0
  tmp_csv(res, "/tmp/ddu-#{month}.csv")
  sleep 100
end


require 'zip'
stringio = Zip::OutputStream.write_buffer do |zio|
  zio.put_next_entry("ddu.csv")
  zio.write report_string
end
