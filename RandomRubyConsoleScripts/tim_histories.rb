report = [%w(BillingPeriod DeviceName CarrierName RatePlan Account AccountState Percentage Bytes SMS MrcAllowance MrcPrice OvgUnit OvgPrice ProratedMrc SingleLineOvgCharge)]
(Date.today.months_ago(12)..Date.today).select { |d| d.day == 1}.each do |date|
  previous = date.months_ago(1)
  new_lines = BillingHistory.where(billing_period: date).pluck(:device_id) - BillingHistory.where(billing_period: previous).pluck(:device_id)
  BillingHistory.includes(:rate_plan, :account).where(billing_period: date, device_id: new_lines).each do |bh|
    report <<
    [date,
     "\t#{bh.device_name}",
     bh.carrier_name,
     bh.rate_plan.memo_name,
     bh.account.account_name,
     bh.account.account_state,
     bh.percentage,
     bh.bytes_used,
     bh.sms_used,
     bh.rate_plan.mrc_data,
     bh.rate_plan.price_mrc_data,
     bh.rate_plan.ovg_data_unit,
     bh.rate_plan.price_ovg_data_unit,
     bh.percentage * bh.rate_plan.price_mrc_data,
     ([bh.bytes_used - (bh.percentage * bh.rate_plan.mrc_data), 0].max / bh.rate_plan.ovg_data_unit).ceil * bh.rate_plan.price_ovg_data_unit
    ]
  end;0
end


