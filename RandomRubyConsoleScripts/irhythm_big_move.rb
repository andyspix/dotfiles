new_rp = RatePlan.find(2332)
old_rp = RatePlan.find(538)
old_rp.devices.find_each { |d| d.update rate_plan: new_rp }
AuditTrail.track("Bulk assigned all devices from #{old_rp.name_id} to rate_plan: #{new_rp.name_id}", username: 'andyspix')
