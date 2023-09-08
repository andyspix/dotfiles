account = Account.find(953)

days = (Date.today.days_ago(90)..Date.today)
report = [['DeviceName', *days.to_a, 'total']]
account.devices.each do |d|
  x = [d.device_name]
  days.each { |day| x += [d.daily_data_usages.find_by(date_for: day)&.bytes_used&.to_i] }
  x += [d.daily_data_usages.where(date_for: days).sum(:bytes_used)]
  report << x
end
report
