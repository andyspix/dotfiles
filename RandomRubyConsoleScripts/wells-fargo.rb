rp = RatePlan.find_by('name like "One Diversified%DEMO%1GB"')
ac = Account.find_by('account_name like "%WELLS-FARGO%"')
assigns = rp.assignments
achs = rp.assignment_change_histories

achs.update_all account_id: ac.id
assigns.update_all account_id: ac.id
rp.update account: ac

Account.find(27).cidr_pools.last.update account: ac

