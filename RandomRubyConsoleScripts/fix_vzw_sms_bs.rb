device = Device.find(424512)

def vzw_sms_as_incremental(device, date = Date.parse('February 1, 2022'))
  date_range = (date.beginning_of_month - 1.day)..date.end_of_month
  fix_hash = Hash[date_range.to_a.zip]
  fix_hash.each_key { |k| fix_hash[k] = 0 }
  device.daily_data_usages.where(date_for: (date.beginning_of_month - 1.day)..date.end_of_month).order(date_for: :asc).pluck(:date_for, :sms_used).to_h
end
