
hashy = InvoiceConfiguration.pluck(:account_id, :netsuite_id).to_h
# (0..29).each do |i|
date = Date.today.beginning_of_month.months_ago(1)
stuff = BillingHistory.joins(:device, :account, :rate_plan).where(billing_period: date).pluck('accounts.id', 'devices.device_name', 'devices.mdn', 'devices.imei', 'devices.state', 'accounts.account_name', 'accounts.account_state', 'rate_plans.name', 'rate_plans.mrc_data', 'rate_plans.price_mrc_data', 'rate_plans.price_ovg_data_unit', 'rate_plans.ovg_data_unit', :billing_period, :starting, :ending, :bytes_used, :sms_used, :percentage, :carrier_name) ; 0
rep = [['netsuite_id', 'iccid', 'mdn', 'imei', 'device_state', 'account_name', 'account_state', 'rate_plan_name', 'rate_plan_mrc_allowance', 'rate_plan_mrc_chg', 'rate_plan_ovg_chg', 'rate_plan_ovg_unit', 'billing_period', 'start', 'end', 'bytes_used', 'sms_used', 'percentage', 'carrier']] + stuff.map{ |x| [hashy[x[0]], *x[1..999]] } ; 0
tmp_csv(rep, "/tmp/billing_history_#{date}.csv")
# end

