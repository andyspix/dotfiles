BillingHistory.where(account_id: 691).find_each.map
devices = BillingHistory.where(account_id: 691).pluck(:device_id).uniq;0

rp_h = Hash.new(0)
rp_h[349] = 5
rp_h[538] = 2.2
rp_h[2332] = 1.0
d_h = Device.where(id: devices).pluck(:id, :device_name).to_h; 0
total_mrcs = devices.map { |d| [d_h[d], BillingHistory.where(device_id: d).sum { |bh| bh.percentage * rp_h[bh.rate_plan_id] }] };0



