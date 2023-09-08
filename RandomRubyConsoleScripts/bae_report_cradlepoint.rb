csv = read_csv('/Users/andyspix/Downloads/MDN.csv')
mdns = csv['MDN'].map { |x| x.delete ',' }
feb = Date.parse('01 Feb 2020')
jan = Date.parse('01 Jan 2020')
dec = Date.parse('01 Dec 2019')

report = [%w(Id DeviceName MDN AllData DecBytes JanBytes FebBytes MultipleOwners CurrentRatePlanName CurrentRatePlanMRC)]
Device.includes(:rate_plan).where(mdn: mdns).each do |d|
  dec_h = d.billing_histories.where(billing_period: dec)
  jan_h = d.billing_histories.where(billing_period: jan)
  feb_h = d.billing_histories.where(billing_period: feb)
  multiple_owners = ([dec_h.pluck(:rate_plan_id), jan_h.pluck(:rate_plan_id), feb_h.pluck(:rate_plan_id)].uniq.count > 1)
  dec_data = dec_h.sum(:bytes_used)
  jan_data = jan_h.sum(:bytes_used)
  feb_data = feb_h.sum(:bytes_used)
  all_data = dec_data + jan_data + feb_data
  report << [d.id, d.device_name, d.mdn, d.rate_plan.name, d.rate_plan.price_mrc_data, all_data, dec_data, jan_data, feb_data, multiple_owners]
end
