# acs = CarrierAccount.where(id: [2, 4, 9])
acs = CarrierAccount.where(id: [4, 9])

now = Date.today
date_range = (now.days_ago(90)..now.end_of_month)
acs.each do |ac|
  report = [['MDN', 'IMEI', 'ICCID', 'ActivationDate', 'State', 'Carrier Rate Plan', 'Account Number', 'DeviceModel', 'UsageSum', *date_range.to_a]]
  ac.devices.find_each do |d|
    line = [d.mdn, d.imei, d.iccid, d.last_activation_date&.strftime('%Y-%m-%d'), d.state, d.carrier_rate_plan, ac.carrier_account_number, nil]
    line << d.daily_data_usages.where(date_for: date_range).sum(:bytes_used)
    date_range.each { |dev| line << d.daily_data_usages.find_by(date_for: dev)&.bytes_used.to_i }
    report << line
  end
  tmp_csv(report)
  system("mv /tmp/tmp_csv.csv /tmp/#{ac.carrier_account_number}.csv")
end


