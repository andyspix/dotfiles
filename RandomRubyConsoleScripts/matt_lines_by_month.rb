date = BillingHistory.last.billing_period
res = {}
CarrierAccount.all.each do |ca|
  devs = ca.devices.pluck :id
  bh = BillingHistory.where(device_id: devs).where.not(rate_plan_id: RatePlan.pws_special_plans.pluck(:id)).where(billing_period: date)
  active = bh.where(percentage: 0.0001..1).pluck(:device_id).uniq.count
  billed = bh.sum(:percentage).round(2)
  everything = bh.pluck(:device_id).uniq.count
  res[ca.carrier_account_name] ||= {}
  res[ca.carrier_account_name][:active] = active
  res[ca.carrier_account_name][:billed_mrcs] = billed
  res[ca.carrier_account_name][:total] = everything
end



