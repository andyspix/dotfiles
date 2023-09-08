all_acts = Account.where(account_state: 'active').where.not(id: [27,1444]).select { |ac| ac.intacct_configuration.intacct_customerid == 'C-0343' }

# 1 set attributes for new plans in each account
new_vzw_attrs = RatePlan.find(2591).attributes
new_pws_attrs = RatePlan.find(2589).attributes
['id', 'account_id', 'name', 'locked', 'created_at', 'updated_at'].each do |a|
  new_vzw_attrs.delete a
  new_pws_attrs.delete a
end

# 2. Create New RPs, Move devices from legacy Rate Plans, backdate to feb28, disable plan
new_rps = []
backdate = Date.parse('February 28, 2023')
ced = Date.parse('December 30, 2023')
all_acts.each do |ac|
  vzw = RatePlan.find_or_create_by({'account_id' => ac.id, 'name' => "#{ac.account_name}-VZW-PUBD-PPU"}.reverse_merge(new_vzw_attrs))
  pws = RatePlan.find_or_create_by({'account_id' => ac.id, 'name' => "#{ac.account_name}-PWS-PUBD-PPU"}.reverse_merge(new_pws_attrs))
  new_rps << vzw
  new_rps << pws
  (ac.rate_plans.enabled.vzw - [vzw]).each do |rp|
    rp.devices.each do |d|
      d.update rate_plan: vzw 
      d.update contract_end_date: ced
      d.backdate_assignment_history(backdate)
    end
    rp.unlock_rate_plan
    rp.update enabled: false
    rp.lock_rate_plan
  end
end


