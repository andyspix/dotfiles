multi_plans = RatePlan.select { |rp| rp.devices.group(:carrier_account_id).pluck(:carrier_account_id).uniq.count >= 2 } - [RatePlan.default, RatePlan.retired, RatePlan.inventory, RatePlan.duplicate]
problem_accounts = Account.where(id: multi_plans.pluck(:account_id).uniq) - Account.special_accounts

carrier_accounts = CarrierAccount.pluck(:carrier_account_name, :id).map {|x| "#{x[0]} (#{x[1]})" }

report = [['AccountNameId', 'RatePlanNameId', 'problem?', *carrier_accounts]]
problem_accounts.each do |ac|
  ac.rate_plans.each do |rp|
    res = []
    res.append ac.name_id
    res.append rp.name_id
    res.append multi_plans.include?(rp)
    CarrierAccount.all.each do |ca|
      count = rp.devices.where(carrier_account_id: ca.id).count
      res.append count.zero? ? nil : count
    end
    report << res
  end
end

tmp_csv(report)
