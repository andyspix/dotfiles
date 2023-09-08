demo_plans = Account.where(account_state: 'demo').collect { |a| a.rate_plans }.flatten
demo_devs = demo_plans.collect { |rp| rp.devices }.flatten
months = demo_devs.collect { |d| d.monthly_data_usages.pluck(:date_for) }.flatten.uniq
rep = [['AccountName', 'AccountState', 'RatePlanNameId', 'DeviceName', *months]]
demo_devs.each do |d|
  rep << [
    d.account.account_name,
    d.account.account_state,
    d.rate_plan.name_id,
    d.device_name,
    *months.map { |m| d.monthly_data_usages.find_by(date_for: m)&.bytes_used || '-' }
  ]
end

zero_devs = RatePlan.where(price_ovg_data_unit: 0).or(RatePlan.where(price_mrc_data: 0)).collect { |rp| rp.devices }.flatten.uniq
months = zero_devs.collect { |d| d.monthly_data_usages.pluck(:date_for) }.flatten.uniq
rep2 = [['AccountName', 'AccountState', 'RatePlanNameId', 'DeviceName', 'price_mrc', 'price_ovg', *months]]
zero_devs.each do |d|
  rep2 << [
    d.account.account_name,
    d.account.account_state,
    d.rate_plan.name_id,
    d.device_name,
    d.rate_plan.price_mrc_data,
    d.rate_plan.price_ovg_data_unit,
    *months.map { |m| d.monthly_data_usages.find_by(date_for: m)&.bytes_used || '-' }
  ]
end
