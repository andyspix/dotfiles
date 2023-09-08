monthly = {}
daily = {}
date = Date.today.months_ago(1).beginning_of_month
end_date = date + 1.month - 1.day
Device.joins(:monthly_data_usages).where('monthly_data_usages.date_for': date).pluck(:id, :'monthly_data_usages.bytes_used').each { |i, b| monthly[i] = b }

ids = DailyDataUsage.where('daily_data_usages.date_for': date..end_date).distinct(:device_id).pluck :device_id;0

ids.in_groups_of(10000) do |group|
  daily.merge! DailyDataUsage.where(device_id: group, 'daily_data_usages.date_for': date..end_date).group(:device_id).sum(:bytes_used)
  print '.'
end

diffs2 = {}
monthly.keys.each do |k|
  next if monthly[k].to_i == daily[k].to_i
  diffs2[k] = monthly[k].to_i - daily[k].to_i
end

Device.where(id: diffs2.keys).group(:carrier_account_id).count.map { |k,v| [CarrierAccount.find(k).carrier_account_name, v] }


