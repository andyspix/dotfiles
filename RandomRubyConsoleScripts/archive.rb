retired_vzw = RatePlan.find(1412).devices.where(carrier_account_id: [1,2,4,9]).pluck(:id);0
max =  AssignmentChangeHistory.where(rate_plan_id: 1412, device_id: retired_vzw).group(:device_id).pluck(:device_id, 'Max(created_at)'); 0

old = max.select { |x,y| y < Date.parse('2021-06-01') };0
old_ids = old.map { |x,y| x }; 0
res = []

handler = VzwApiHandler.new

puts Time.now
info = Device.where(id: old_ids).limit(100).map { |d| handler.device_info(d) }

Device.where(id: old_ids).in_batches(of: 50) { |batch| Device.archive_device_ids(batch.pluck(:id), i_am_sure: true) }
