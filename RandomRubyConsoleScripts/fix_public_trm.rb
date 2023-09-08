# ONLY SHOULD DO THIS FOR DAINTREE FOR NOW....
bad_date = Time.parse('Wed, 24 Apr 2019 00:00:00 UTC +00:00')
rp_id = RatePlan.where('name like "%VZWPublic :: (%"').pluck(:id);0
rp_id = 820
devices = Device.where(id: Assignment.where(rate_plan_id: rp_id).pluck(:device_id));0

live_dates = {}
devices.each do |d|
  next if d.mdn.nil?
  wn = d.mdn[0..2] + '-' + d.mdn[3..5] + '-' + d.mdn[6..9]
  date = PublicBillingDatum.where(wireless_number: wn).order(created_at: :asc).first&.created_at
  live_dates[d.id] = date unless date.nil?
end;0

before = devices.map { |d| d.first_activation(d.rate_plan.id) }
devices.each do |d|
  next if live_dates[d.id].nil?

  delta = bad_date - live_dates[d.id]
  next if delta.negative?

  d.assignment_change_histories.each do |ach|
    ach.created_at -= delta
    ach.updated_at -= delta
    ach.save
  end
  d.state_change_histories.each do |sch|
    sch.created_at -= delta
    sch.updated_at -= delta
    sch.save
  end
end
after = devices.map { |d| d.first_activation(d.rate_plan.id) }
