data = read_csv '/tmp/commission_costs.csv'

res = data.each do |d|
  rp =     RatePlan.find_by name: d['Rate Plan']
  cost =   d['Pws cost']
  new_c =  d['New Cost']
  next if new_c.nil?

  cc = CommissionConfiguration.find_by(rate_plan_id: rp.id)
  next if cc.pws_cost.to_f != cost.to_f

  cc.update pws_cost: new_c.to_f
end


rp =     RatePlan.find_by name: data.first['Rate Plan']
cost =   data.first['Pws cost']
new_c =  data.first['New Cost']
  cc = CommissionConfiguration.find_by(rate_plan_id: rp.id)
  cc.pws_cost.to_f == cost.to_f





