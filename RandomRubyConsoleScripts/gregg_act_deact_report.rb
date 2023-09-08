rep = [%w(DeviceName DeviceRatePlan CreatedAt DeactivatedAt)]
Device.where(created_at: Date.today.years_ago(3).beginning_of_year..Date.today).includes(:carrier, :state_change_histories, :rate_plan).find_each do |d|
  time = if d.state_change_histories.nil? || d.carrier.terminated_states.exclude?(d.state_change_histories&.last&.state)
           ''
         else
           d.state_change_histories.last.created_at
         end
  rep << [d.device_name, d.rate_plan.name_id, d.created_at.to_date, time.to_date]
end;0

rep << [,,,]
rep << [,,,]
rep << [,,,]
rep << %w(Month Activations Deactivations)
months = (Date.today.years_ago(3).beginning_of_year..Date.today.months_ago(1).beginning_of_month).select {|d| d.day == 1}
months.each do |m|
  acts = rep.count { |x,y,z,w| (m..m.end_of_month).include?(z) }
  deacts = rep.count { |x,y,z,w| (m..m.end_of_month).include?(w) }
  rep << [m, acts, deacts]
end;0


# BCYCLE report for Mark
lifetime_devs = AssignmentChangeHistory.where(rate_plan_id: 1892).or(AssignmentChangeHistory.where(previous_rate_plan_id: 1892)).pluck(:device_id)
res = StateChangeHistory.where(device_id: lifetime_devs, state: ['deactive']).pluck(:device_id, :created_at).map { |d, t| x = Device.find(d); [x.device_name, x.imei, x.created_at, t, x.rate_plan.name_id, x.state] }
tmp_csv [%w(deviceName IMEI createdAt deactivatedOn currentRatePlan currentState)] + res
