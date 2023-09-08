d_range = (Date.today.months_ago(12)..Date.today).select { |d| d.day == 1 }
rp_hash = RatePlan.all.map { |x| [x.id, x.memo_name] }.to_h
act_ids = Account.needs_billing.pluck(:id)
rep = [%w(DeviceName CarrierAccountName CarrierRatePlanName CommissionedPrice PwsRatePlanDescription MrcAllowance OvgUnit MrcPrice OvgPrice AvgMegabytesPerMonth)] +
  Device.joins(:account).includes(:rate_plan, :carrier_account).where('accounts.id': act_ids).map do |d|
      dus = d.monthly_data_usages.where(date_for: d_range).sum(:bytes_used)
      avg = ((30.5 * dus) / 1048576) / ((Date.today - d_range.first).to_i)
      [
        "#{d.device_name}\t",
        d.carrier_account.carrier_account_name,
        d.carrier_rate_plan,
        helper.number_to_currency(d.rate_plan.commission_configuration&.pws_cost),
        rp_hash[d.rate_plan.id],
        helper.number_to_human_size(d.rate_plan.mrc_data),
        helper.number_to_human_size(d.rate_plan.ovg_data_unit),
        helper.number_to_currency(d.rate_plan.price_mrc_data),
        helper.number_to_currency(d.rate_plan.price_ovg_data_unit),
        avg
      ]
end;0

# Invoice charting

d_range = (Date.today.months_ago(12)..Date.today).select { |d| d.day == 1 }
rep = [['Account', *d_range]]
IntacctInvoiceHistory.distinct(:account_number_name).pluck(:account_number_name).each do |ann|
  row = [ann]
  d_range.each do |d|
    row += [IntacctInvoiceHistory.find_by(account_number_name: ann, date_posted: d..d.end_of_month)&.total_due]
  end
  rep << row
end



