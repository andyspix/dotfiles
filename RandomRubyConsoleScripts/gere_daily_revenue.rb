
def report(date = Date.today)
  [%w(Account RatePlan TotalDevices BillableDevices MRC MonthlyRevenueForecast)] +
  Account.order(:account_name).needs_billing.includes(:rate_plans).map do |ac|
    ac.rate_plans.map do |rp|
      billable_devs = rp.devices.includes(:carrier, :monthly_data_usages).select { |d| d.billable?(date) }.count
      [ac.account_name, rp.memo_name, rp.devices.count, billable_devs, rp.price_mrc_data, billable_devs * rp.price_mrc_data]
    end
  end.flatten(1)
end

File.open('/tmp/dec.csv', 'w') { |f| f.write(report(Date.today.months_ago(1)).inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }
File.open('/tmp/nov.csv', 'w') { |f| f.write(report(Date.today.months_ago(2)).inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }
File.open('/tmp/oct.csv', 'w') { |f| f.write(report(Date.today.months_ago(3)).inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }
File.open('/tmp/sept.csv', 'w') { |f| f.write(report(Date.today.months_ago(4)).inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }

def report2(date = Date.today)
  [%w(Account RatePlan TotalDevices BillableDevices MRC MonthlyRevenueForecast)] +
  Account.order(:account_name).needs_billing.includes(:rate_plans).map do |ac|
    ac.rate_plans.map do |rp|
      billable_devs = BillingHistory.where(billing_period: date.beginning_of_month.months_ago(1), rate_plan_id: rp.id).sum(:percentage) * 1 / 4 +
                      BillingHistory.where(billing_period: date.beginning_of_month.months_ago(2), rate_plan_id: rp.id).sum(:percentage) * 3 / 4
      devs = BillingHistory.where(billing_period: date.beginning_of_month.months_ago(1), rate_plan_id: rp.id).group(:device_id).count.count * 1 / 4 +
             BillingHistory.where(billing_period: date.beginning_of_month.months_ago(2), rate_plan_id: rp.id).group(:device_id).count.count * 3 / 4
      [ac.account_name, rp.memo_name, devs, billable_devs, rp.price_mrc_data, billable_devs * rp.price_mrc_data]
    end
  end.flatten(1)
end

