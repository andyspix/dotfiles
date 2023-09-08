singles_cnt = Device.group(:iccid).count.select {|k,v| v == 1}.count
doubles_cnt = Device.group(:iccid).count.select {|k,v| v == 2}.count
others_cnt = Device.group(:iccid).count.select {|k,v| v > 4}.count

# Script to handle the 'easy ones'
dup_iccids = Device.group(:iccid).count.select {|k,v| v == 2}.keys;0
easy_iccids = Device.where(iccid: dup_iccids).joins(:account).where('accounts.id': 1).pluck(:iccid);0
retired_iccids = Device.where(iccid: dup_iccids).joins(:account).where('accounts.id': 49).pluck(:iccid);0

easy_iccids.each do |iccid|
  pair = Device.where(iccid: iccid)
 # Simple case, 1 in master, in customer
  old = pair.joins(:account).where.not('accounts.id': 1).take
  new = pair.joins(:account).where('accounts.id': 1).take

  # special case both devices in master account
  if old.nil?
    old = pair.order(id: :asc).first
    new = pair.order(id: :asc).last
  end

  next unless old.meid == old.device_name && new.meid.nil? && new.device_name == old.iccid

  ActiveRecord::Base.transaction do
    old.device_name = new.device_name
    old.pws_note = "Renamed from: #{old.device_name}"
    old.note3 = "Renamed from: #{old.device_name}" if old.note3.blank?
    new.assignment&.destroy
    new.view_configuration&.destroy
    new.state_change_histories.destroy_all
    new.daily_data_usages.destroy_all
    new.monthly_data_usages.destroy_all
    new.device_reports.destroy_all
    new.calamp_device&.destroy
    new.geocode_history&.destroy
    new.queclink_messages.destroy_all
    new.operation_tickets.destroy_all

    new.destroy
    old.save!
  end
end

# Bad retired devices
Device.where(iccid: dup_iccids).joins(:account).where('accounts.id': 49).each do |dev|
  ActiveRecord::Base.transaction do
  dev.assignment&.destroy
  dev.view_configuration&.destroy
  dev.state_change_histories.destroy_all
  dev.daily_data_usages.destroy_all
  dev.monthly_data_usages.destroy_all
  dev.device_reports.destroy_all
  dev.calamp_device&.destroy
  dev.geocode_history&.destroy
  dev.queclink_messages.destroy_all
  dev.operation_tickets.destroy_all
  dev.sublet&.destroy
  dev.destroy
  end
end

# Stale ESN Data
Device.joins(:account).where(iccid: dup_iccids).where('accounts.id': 1).select { |d| d.esn == d.device_name }.each do |dev|
  ActiveRecord::Base.transaction do
  dev.assignment&.destroy
  dev.view_configuration&.destroy
  dev.state_change_histories.destroy_all
  dev.daily_data_usages.destroy_all
  dev.monthly_data_usages.destroy_all
  dev.device_reports.destroy_all
  dev.calamp_device&.destroy
  dev.geocode_history&.destroy
  dev.queclink_messages.destroy_all
  dev.operation_tickets.destroy_all
  dev.sublet&.destroy
  dev.destroy
  end
end

# misc crap in PWS accounts we can nuke safely:
Device.where(id: [185980, 184940, 184943, 184947, 167847]).each do |dev|
    ActiveRecord::Base.transaction do
  dev.assignment&.destroy
  dev.view_configuration&.destroy
  dev.state_change_histories.destroy_all
  dev.daily_data_usages.destroy_all
  dev.monthly_data_usages.destroy_all
  dev.device_reports.destroy_all
  dev.calamp_device&.destroy
  dev.geocode_history&.destroy
  dev.queclink_messages.destroy_all
  dev.operation_tickets.destroy_all
  dev.sublet&.destroy
  dev.destroy
  end
end

# Corrupted ESN mappings from wrong order new calls
Device.where(id: [185980, 184940, 184943, 184947, 167847]).each do |dev|
    ActiveRecord::Base.transaction do
  dev.assignment&.destroy
  dev.view_configuration&.destroy
  dev.state_change_histories.destroy_all
  dev.daily_data_usages.destroy_all
  dev.monthly_data_usages.destroy_all
  dev.device_reports.destroy_all
  dev.calamp_device&.destroy
  dev.geocode_history&.destroy
  dev.queclink_messages.destroy_all
  dev.operation_tickets.destroy_all
  dev.sublet&.destroy
  dev.destroy
  end
end

# True Oddballs
dup_iccids = Device.where.not(state: 'deactive').group(:iccid).count.select {|k,v| v == 2}.keys;0
Device.joins(:account).where(iccid: dup_iccids).pluck(:iccid, :id, 'DATE(devices.last_connection_date)', 'DATE(devices.created_at)', :state, :ip_address, :'accounts.account_name', :'accounts.account_state', :meid, :esn, :imsi, :device_name).map { |x| x.join('|') };0

# Manually running DIA cron with iccid as new root of trust:
dup_iccids = Device.group(:iccid).count.select {|k,v| v == 2}.keys;0
easy_iccids = Device.where(iccid: dup_iccids).joins(:account).where('accounts.id': 1).pluck(:iccid);0
pp Device.joins(:account).where(iccid: easy_iccids).pluck(:iccid, :id, 'DATE(devices.last_connection_date)', 'DATE(devices.created_at)', :state, :ip_address, :'accounts.account_name', :'accounts.account_state', :meid, :esn, :imsi, :device_name).map { |x| x.join('|') };0

easy_iccids.each do |iccid|
  pair = Device.where(iccid: iccid)
 # Simple case, 1 in master, in customer
  old = pair.joins(:account).where.not('accounts.id': 1).take
  new = pair.joins(:account).where('accounts.id': 1).take

  # special case both devices in master account
  if old.nil?
    old = pair.order(id: :asc).first
    new = pair.order(id: :asc).last
  end

  ActiveRecord::Base.transaction do
    old.device_name = new.device_name
    old.pws_note = "Renamed from: #{old.device_name}"
    old.note3 = "Renamed from: #{old.device_name}" if old.note3.blank?
    new.assignment&.destroy
    new.view_configuration&.destroy
    new.state_change_histories.destroy_all
    new.daily_data_usages.destroy_all
    new.monthly_data_usages.destroy_all
    new.device_reports.destroy_all
    new.calamp_device&.destroy
    new.geocode_history&.destroy
    new.queclink_messages.destroy_all
    new.operation_tickets.destroy_all

    new.destroy
    old.save!
  end
end
