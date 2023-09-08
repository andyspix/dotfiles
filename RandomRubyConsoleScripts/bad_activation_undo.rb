devs = Device.where(device_name: %w( 89148000007473693006 89148000007473699482 89148000007473699490) )

devs.each do |d|
  d.assignment_change_histories.last.destroy
  d.rate_plan = RatePlan.retired
  d.account = Account.default_account
  d.save
end
