mn3 = Date.parse("01 dec 2020")
mn2 = (mn3 - 1.month).beginning_of_month
mn1 = (mn2 - 1.month).beginning_of_month

def andy
  { x: :y}
end
def devices_in_plan_during_month(rp, date, prorated=true)
  # Sum billing history data to determine what was there, estimate if
  # billing cycle hasn't closed in the period and thus no histories exist
  period = date.beginning_of_month

  if prorated
    rp.billing_histories.where(billing_period: period).sum(:percentage) # ledgered data
  else
    rp.billing_histories.where(billing_period: period).where(deactivation_count: 0).group(:device_id).count.count
  end
end

report = [[ 'RatePlan', 'Carrier', 'Id', mn1.to_formatted_s + '-prorated', mn1.to_formatted_s + '-all', mn1.to_formatted_s + '-pro-line-counts', mn2.to_formatted_s + '-prorated', mn2.to_formatted_s + '-all', mn2.to_formatted_s + '-pro-line-counts', mn3.to_formatted_s + '-prorated', mn3.to_formatted_s + '-all', mn3.to_formatted_s + '-pro-line-counts' ]]
RatePlan.all.each do |rp|
  mn1_p = devices_in_plan_during_month(rp, mn1, true)
  mn1_a = devices_in_plan_during_month(rp, mn1, false)
  mn1_plc = rp.billing_histories.where(billing_period: mn1).where('percentage > 0').count
  mn2_p = devices_in_plan_during_month(rp, mn2, true)
  mn2_a = devices_in_plan_during_month(rp, mn2, false)
  mn2_plc = rp.billing_histories.where(billing_period: mn2).where('percentage > 0').count
  mn3_p = devices_in_plan_during_month(rp, mn3, true)
  mn3_a = devices_in_plan_during_month(rp, mn3, false)
  mn3_plc = rp.billing_histories.where(billing_period: mn3).where('percentage > 0').count
  report << [rp.name, rp.carrier.carrier_name, rp.id, mn1_p, mn1_a, mn1_plc, mn2_p, mn2_a, mn2_plc, mn3_p, mn3_a, mn3_plc]
end

tmp_csv report
