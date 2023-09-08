mdns = Account.find(1).devices.pluck :mdn
devs = Device.where(mdn: mdns - [nil]);0
dups = devs.group(:mdn).count.select {|x,y| y > 1}.keys
mdn_csv = dups.join(',') # For pasting into Lattigo

dups.each do |mdn|
  acts = Device.includes(:account).where(mdn: mdn).pluck(:'accounts.account_name') - ['(PWS Master Account)', '(PWS_DUPLICATE_DEVICES)']
  # found a single dup in PWS Master, move it to dup account
  if acts.length == 1
    d = Account.default_account.devices.find_by(mdn: mdn)
    d.territories.delete_all
    d.rate_plan = RatePlan.duplicate
    d.account = RatePlan.duplicate.account
    AuditTrail.track("Assigned #{d.name_id} to rate_plan: #{d.rate_plan.name_id}")
    d.save
  end
end
