# Devs, Gregg - can pretend to be sales
[69, 71, 73, 74, 761].each { |uid| AllowedPassport.create(user_id: uid, passport_id: 11) }

# Roevic, Gere - leave be
[72, 143].each

# Ben, Mark, Marius - leave be
[72, 143].each

AuditTrail.where(username: 'clarence').where('short_description like "%Deactivate%"').map do |at|
  md = at.short_description.match(/.*: (\S+) /)
  res = md ? md[1] : nil
  dev = Device.find_by(device_name: res)
  pws = ['(PWS Master Account)', '(PWS Retired Devices)']
  accounts = dev ? (dev.assignment_change_histories.joins(:account).pluck(:'accounts.account_name') - pws).join(',') : nil
  [res, at.created_at, accounts]
end
