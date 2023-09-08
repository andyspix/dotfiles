rp = RatePlan.find(248)
current = rp.devices.pluck :id
old = AssignmentChangeHistory.where(previous_rate_plan_id: 248).pluck :device_id

rep = [['DeviceName', 'IMEI', 'CurrentState', 'StateLastChanged']]
Device.includes(:state_change_histories).where(id: current + old).each { |d| rep << [d.device_name, d.imei, d.state, d.state_change_histories.last.created_at] }
tmp_csv(rep)
