[1927, 245, 298, 80, 877, 557]

devs1 = RatePlan.find(1927).devices.pluck :id
devs2 = RatePlan.find(245).devices.pluck :id
devs3 = RatePlan.find(298).devices.pluck :id
devs4 = RatePlan.find(80).devices.pluck :id
devs5 = RatePlan.find(877).devices.pluck :id
devs6 = RatePlan.find(557).devices.pluck :id
rep = (Date.today.days_ago(90)..Date.today).map do |date|
[
date,
DailyDataUsage.where(device_id: devs1, date_for: date).sum(:bytes_used) / devs1.count,
DailyDataUsage.where(device_id: devs2, date_for: date).sum(:bytes_used) / devs2.count,
DailyDataUsage.where(device_id: devs3, date_for: date).sum(:bytes_used) / devs3.count,
DailyDataUsage.where(device_id: devs4, date_for: date).sum(:bytes_used) / devs4.count,
DailyDataUsage.where(device_id: devs5, date_for: date).sum(:bytes_used) / devs5.count,
DailyDataUsage.where(device_id: devs6, date_for: date).sum(:bytes_used) / devs6.count
]

end



