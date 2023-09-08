def report(rp, date)
  bhs = BillingHistory.where(rate_plan_id: rp.id, billing_period: date.beginning_of_month)
  all_lines = bhs.group(:device_id).count.count
  zero_lines = bhs.where(bytes_used: 0, percentage: 0).count + bhs.where(bytes_used: 0).where.not(percentage: 0).sum(:percentage)
  data_lines = all_lines - zero_lines
  data_used = bhs.sum(:bytes_used)  / 1024.0
  avg_use = data_lines.zero? ? 0 : data_used / data_lines.to_f
  reps = rp.commission_configuration.nil? ? 'Unknown' : [rp.commission_configuration.rep1, rp.commission_configuration.rep2].compact.join(' + ')
  [date.to_formatted_s(:year_month), rp.account.account_name, rp.carrier.carrier_name, rp.name_id, reps, all_lines, zero_lines, data_lines, data_used, avg_use]
end


res = [%w(Cycle Customer Carrier RatePlan CommissionedReps ActiveLines ZeroLines LinesWithData TotalDataKB AveragePerLineWithDataKB)] +
  RatePlan.enabled.map { |rp| report(rp, Date.today.months_ago(1)) }













