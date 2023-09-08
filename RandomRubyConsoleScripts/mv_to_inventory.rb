nid = RatePlan.find(1413).name_id
devs = Device.where(id: Assignment.where(rate_plan_id: 1411).pluck(:device_id)).where(state: ['test ready', 'inventory', 'stock'])
devs.each do |d|
  d.assignment.update rate_plan_id: 1413, account_id: 1
  AuditTrail.track("Assigned #{d.name_id} to rate_plan: #{nid}", username: 'andyspix')
end

devs = Device.where(id: Assignment.where(rate_plan_id: 1411).pluck(:device_id), carrier_account_id: 12).select { |d| d.monthly_data_usages.sum(:bytes_used).zero? }.
devs.each do |d|
  d.assignment.update rate_plan_id: 1413, account_id: 1
  AuditTrail.track("Assigned #{d.name_id} to rate_plan: #{nid}", username: 'andyspix')
end


