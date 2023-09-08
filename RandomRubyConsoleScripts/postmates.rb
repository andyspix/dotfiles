data = [%w(DeviceName ActivationAgeDays InTrm? LifeTimeDataUsage 60kbDate FirstBillingPeriod)]

def find_first60(device)
  bytes = 0
  date_for = 'NA'
  device.daily_data_usages.pluck(:bytes_used, :date_for).each do |bu, df|
    bytes += bu
    date_for = df if bytes >= 60 * 1024
    break if bytes >= 60 * 1024
  end
  date_for
end

Account.find(106).devices.each do |x|
  waive = x.test_ready_waive_mrc
  days_active = x.activation_age / 60 / 60 / 24
  first_bill_cycle = BillingHistory.where(device_id: x.id).where.not(percentage: 0).first&.billing_period || 'N/A'
  data << [
    x.device_name,
    days_active,
    waive,
    ActionController::Base.helpers.number_to_human_size(x.monthly_data_usages.sum(:bytes_used).to_i),
    find_first60(x),
    first_bill_cycle
  ]
end

tmp_csv(data)
