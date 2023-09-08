CarrierAccount.find([2,4,9]).each do |ca|
  ca.joins(:devices  :monthly_data_usages, :daily_data_usages)
end

# CA2 = Private, 100k devices
# CA4 = DIA, 100k devices
# CA9 = Public, 65k devices


jan = Date.parse('2021-01-01')
feb = Date.parse('2021-02-01')
march = Date.parse('2021-03-01')
CarrierAccount.find([2,4,9]).map do |ca|
  monthly_sum = ca.devices.joins(:monthly_data_usages).where('monthly_data_usages.date_for': march).sum('monthly_data_usages.bytes_used')
  daily_sum = du_in_range(ca, march..march.end_of_month)
  ms = helper.number_to_human_size(monthly_sum)
  ds = helper.number_to_human_size(daily_sum)
  "CA: #{ca.carrier_account_name} -- Monthly: #{ms} -- Daily: #{ds}"
end

def du_in_range(thing_with_devices, cycle)
  thing_with_devices.devices.joins(:daily_data_usages).where('daily_data_usages.date_for': cycle).sum('daily_data_usages.bytes_used')
end

priv = CarrierAccount.find(2)
dia = CarrierAccount.find(4)
pub = CarrierAccount.find(9)
result = [%w(Date Private Date DIA Date Public)]
(Date.parse('2020-10-01')..Date.today).each do |d|
  result << [d.to_s, du_in_range(priv, d), d.to_s, du_in_range(dia, d), d.to_s, du_in_range(pub, d)]
end

result = [%w(Date Volta Date DMG Date Cobalt Date Hornblower Date Daintree Date Microspace Date OneMedical Date ECAM Date DoorDash)]
(Date.parse('2020-10-01')..Date.today).each do |date|
  row = []
  Account.find([114,319,831,915,270,938,1110,939,68]).each do |ac|
    row += [date.to_s]
    row += [ac.devices.where(carrier_account_id: 9).joins(:daily_data_usages).where('daily_data_usages.date_for': date).sum('daily_data_usages.bytes_used')]
  end
  result << row
end


