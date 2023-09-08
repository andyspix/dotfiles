overpaid = { '450' => 1, '457' => 1, '608' => 1, '638' => 1, '662' => 1, '668' => 1, '738' => 1, '1041' => 1, '1060' => 1, '1064' => 1, '1124' => 1, '1127' => 1, '1319' => 1, '1402' => 1, '1486' => 1, '1528' => 1, '1601' => 1, '1705' => 1, '1706' => 1, '1737' => 1, '1760' => 1, '1761' => 1, '1774' => 1, '1784' => 1, '1849' => 1, '1857' => 1, '1895' => 1, '1901' => 1, '1902' => 1, '1906' => 1, '1936' => 1, '248' => 2, '405' => 2, '837' => 2, '1026' => 2, '1062' => 2, '1315' => 2, '1329' => 2, '1655' => 2, '1752' => 2, '1850' => 2, '1866' => 2, '1898' => 2, '1948' => 2, '1949' => 2, '17' => 3, '109' => 3, '122' => 3, '1251' => 3, '1718' => 3, '1806' => 3, '429' => 4, '554' => 4, '1700' => 4, '1804' => 4, '320' => 5, '605' => 5, '1425' => 5, '1656' => 5, '1687' => 5, '1758' => 5, '265' => 6, '1586' => 6, '1772' => 6, '300' => 7, '913' => 7, '1762' => 7, '894' => 8, '1379' => 8, '1664' => 8, '316' => 9, '123' => 10, '1083' => 10, '1619' => 10, '1626' => 10, '1907' => 10, '462' => 11, '1192' => 11, '1458' => 11, '1871' => 12, '551' => 14, '1847' => 14, '374' => 17, '1734' => 17, '1618' => 19, '1872' => 19, '131' => 20, '395' => 21, '920' => 21, '916' => 22, '1617' => 23, '1644' => 25, '1672' => 25, '325' => 29, '1592' => 30, '1763' => 31, '331' => 35, '1169' => 38, '1451' => 40, '1765' => 50, '1502' => 51, '1419' => 66, '1681' => 73, '1176' => 74, '1768' => 85, '92' => 95, '1892' => 117, '877' => 218, '820' => 229, '1325' => 247, '1911' => 377, '1951' => 387, '1886' => 431, '1927' => 510, '1840' => 674, '1823' => 1033 }

force_them = {}
review = {}
house_date = CommissionHistory.first.issued_on
CommissionHistory.where.not(issued_on: house_date).delete_all
overpaid.each do |k, v|
  rp = RatePlan.find(k)
  plan_devices = rp.devices.pluck :id
  settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
  can_force = plan_devices - settled_devices
  if can_force.count >= v
    # we have enough to force settlements
    force_them[k] = v
  else
    force_them[k] = can_force.count
    review[k] = v - can_force.count
  end
end

force_them.each do |k, v|
  rp = RatePlan.find(k)
  plan_devices = rp.devices.pluck :id
  settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
  candidates = plan_devices - settled_devices
  Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
    CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
  end
end

# Now manually handle any mismatches with 10 or more devices left, the rest we call slop

# "1840" => 674, moved to 1980
v = 674
rp = RatePlan.find(1980)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1886" => 431, moved to 1960
v = 431
rp = RatePlan.find(1960)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1325" => 247, BOINGO - dead

# "820" => 229, Daintree moved to 1927
v = 229
rp = RatePlan.find(1927)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end


# "92" => 95, DOR, all paid somewhere

# "1176" => 74, moved to 1892
v = 74
rp = RatePlan.find(1892)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1681" => 73, moved to 1996
v = 73
rp = RatePlan.find(1996)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1419" => 66, Memomi - cancelled a bunch

# "1502" => 51, moved to 1976
v = 51
rp = RatePlan.find(1976)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1765" => 50, cancelled TMO
# "325" => 29, cancelled TMO
# "1672" => 25, cancelled VZW
# "916" => 22, cancelled Datawrx

# "395" => 21, Heartland account move, new RP 1996
v = 21
rp = RatePlan.find(1996)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "920" => 21, RMS life safety, cancelled?
v = 21
rp = RatePlan.find(1996)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1618" => 19, look like cancels
# "374" => 16, look like cancels
# "551" => 14, DOR, possible cancels
# "1617" => 14, looks simply overpaid, possibly cancels?
# "1192" => 11, cancelled account?
# "462" => 11, old, cancelled
# "1458" => 11, possible double payment, no recourse
# "1626" => 10, cancelled ATT

# "1083" => 10, moved to 1951
v = 10
rp = RatePlan.find(1951)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

# "1907" => 10, moved to 1911
v = 10
rp = RatePlan.find(1911)
plan_devices = rp.devices.pluck :id
settled_devices = CommissionHistory.where(rate_plan_id: rp.id).pluck :device_id
candidates = plan_devices - settled_devices
Device.where(id: candidates).order(created_at: :asc).limit(v).each do |d|
  CommissionHistory.create(device_id: d.id, rate_plan_id: rp.id, issued_on: house_date, issued_to: 'House', pws_cost_at_time: 0, price_mrc_data_at_time: 0, state: 'settled', settlement_date: house_date + 1.day, amount: 0)
end

sept = Date.parse('01-10-2020').days_ago(1)
CommissionHistory.generate_new(sept + 31.days)
CommissionHistory.generate_new
