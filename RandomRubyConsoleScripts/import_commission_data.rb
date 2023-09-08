CommissionConfiguration.seed_from_rate_plans
data = read_csv('/tmp/comissions_to_import.csv')
cc_hash = {}
errors = []
data.each do |d|
  rp = RatePlan.find_by(name: d['rate_plan_name'])
  errors << d['rate_plan_name'] if rp.nil?
  next if rp.nil?
  cc_hash[rp.id] = {
    rep1: d['rep1'],
    rep2: d['rep2'],
    rep1_pct: d['rep1_pct'].nil? ? 100 : d['rep1_pct'],
    rep2_pct: d['rep2_pct'],
    pws_cost: d['pws_cost']
  }
end

puts errors

errs = []
skips = []
CommissionConfiguration.all.each do |cc|
  skips << [cc.rate_plan&.name, cc.rate_plan.created_at] unless cc_hash.key? cc.rate_plan_id
  next unless cc_hash.key? cc.rate_plan_id
  rp_id = cc.rate_plan_id

  cc.rep1 = cc_hash[rp_id][:rep1]
  cc.rep2 = cc_hash[rp_id][:rep2]
  cc.rep1_pct = cc_hash[rp_id][:rep1_pct]
  cc.rep2_pct = cc_hash[rp_id][:rep2_pct]
  cc.pws_cost = cc_hash[rp_id][:pws_cost]
  errs << cc unless cc.valid?
  cc.save
  cc.lock_configuration if cc.valid?
end

puts errs
puts skips
