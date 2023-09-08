source '/tmp/xaa'
chosen_rp = RatePlan.find(2305)
assign_time = Date.today.days_ago(1).beginning_of_month - 1.minute
act = chosen_rp.account
devices.each do |d|
  d.rate_plan = chosen_rp
  d.account = act
  d.remove_all_rules
  d.backdate_assignment_history(assign_time, true)
  d.save
end


chosen_rp = RatePlan.inventory
act = chosen_rp.account
devices.each do |d|
  d.rate_plan = chosen_rp
  d.account = act
  d.remove_all_rules
  d.save
end




