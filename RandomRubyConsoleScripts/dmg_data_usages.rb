ac = Account.find(319)

now = Date.parse('September 15, 2020')
date_range = (now.beginning_of_month..now.end_of_month)

report = [['SIM', *date_range.to_a, 'UsageSum', 'IpAddress', 'Note', 'Note1', 'Note2', 'Note3']]
ac.devices.each do |dev|
  line = [dev.device_name]
  date_range.each { |d| line << dev.daily_data_usages.find_by(date_for: d)&.bytes_used.to_i }
  line << dev.daily_data_usages.where(date_for: date_range).sum(:bytes_used)
  line << dev.ip_address
  line << dev.note
  line << dev.note1
  line << dev.note2
  line << dev.note3
  report << line
end

tmp_csv(report)
