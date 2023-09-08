boingo = PublicBillingDatum.where(public_cost_center_id: 675);
numbers = boingo.pluck(:wireless_number).uniq

result = {}
numbers.each { |num| result[num] = boingo.where(wireless_number: num).order(created_at: :asc).pluck(:created_at).first }
mapping = {}

result.each do |k,v|
  mdn = k[0..2] + k[4..6] + k[8..11]
  d = Device.find_by(mdn: mdn)
  next unless d.account.id == 829
  d.contract_end_date = v - 28.days + 2.years
  d.save
end
