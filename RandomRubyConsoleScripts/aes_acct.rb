act = Account.find(1367)
new_act = Account.new act.attributes
new_act.id = nil
new_act.account_state = 'active'
new_act.save
new_act.change_lattigo_subscription 'BASE'

act.account_name = 'Alternative Energy Systems, Inc. - AES (legacy prepay)'
act.save

rp = RatePlan.find(2348)
rp.unlock_rate_plan
rp.update account_id: new_act.id
rp.lock_rate_plan
Assignment.where(rate_plan_id: rp.id).update_all account_id: new_act.id
AssignmentChangeHistory.where(rate_plan_id: rp.id).update_all account_id: new_act.id

pp_rp = RatePlan.find(2292)

csv = read_csv('/tmp/aes.csv')
csv.each do |c|
  d = Device.find(c['d_id'])
  if c['move'] == 'TRUE'
    d.update rate_plan: rp
    d.update contract_end_date: Date.today
  end
end


# Update the account via UI, add a primary user
# Move the out of prepay lines to this account
