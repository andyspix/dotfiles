acc = Account.find(1028)
all_iccids = acc.devices.pluck(:iccid)
data1 = acc.devices.joins(:state_change_histories).where('state_change_histories.previous_state': 'suspend'); 0
data2 = acc.devices.joins(:state_change_histories).where('state_change_histories.state': 'suspend'); 0
data3 = data1.pluck(:iccid, :'state_change_histories.state', :'state_change_histories.previous_state', :'state_change_histories.created_at');0
data4 = data2.pluck(:iccid, :'state_change_histories.state', :'state_change_histories.previous_state', :'state_change_histories.created_at');0
missing = all_iccids - data3.map(&:first).uniq - data4.map(&:first).uniq
actives = Device.where(iccid: missing).select { |d| d.state_change_histories.count == 1 }
weirds = Device.where(iccid: missing).reject { |d| d.state_change_histories.count == 1 }

hash = {}

data3.each do |d|
  hash[d[0]] ||= []
  hash[d[0]] << { state: d[1], prev: d[2], time: d[3] };0
end; 0

data4.each do |d|
  hash[d[0]] ||= []
  hash[d[0]] << { state: d[1], prev: d[2], time: d[3] };0
end; 0

results = [%w(Iccid DaysSuspended SuspensionCount CurrentState SuspendedOn, ActivatedDaysAgo)]
hash.each do |k,v|
  suspension_count = 0
  time_suspended = 0
  suspended_at = nil
  last_state = nil
  dates = ''
  v.sort_by{ |x| x[:time] }.each do |y|
    last_state = y[:state]
    if last_state == 'active' && !suspended_at.nil?
      time_suspended += y[:time] - suspended_at
      suspended_at = nil
    elsif last_state == 'suspend' && time_suspended.zero?
      suspension_count += 1
      time_suspended = 1
      suspended_at = y[:time]
      dates << "'#{y[:time].to_date.to_s} "
    else
      suspension_count += 1
      suspended_at = y[:time]
      dates << "#{y[:time].to_date.to_s} "
    end
  end
  time_suspended = (Time.now - suspended_at) if last_state == 'suspend'
  results << [k, (time_suspended / 86400).round(2) , suspension_count, last_state, dates, (Date.today - Device.find_by(iccid: k).created_at.to_date).to_i]
end;0

tmp_csv(results)
