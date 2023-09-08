chosen_rp = RatePlan.find(2529)
RatePlan.find(1417).devices.each do |d|
  d.rate_plan = chosen_rp
  d.remove_all_rules
  d.save
end



