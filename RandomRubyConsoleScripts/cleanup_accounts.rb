Account.group(:account_state).count
# {"active"=>791, "cancelled"=>424, "demo"=>45, "nonpayment-hold"=>1, "not-billed-misc"=>40, "prepaid"=>3}

# Empties:
empties = Account.where(account_state: 'active').select { |a| a.devices.count.zero? }
old_empties = empties.select { |a| a.created_at < Date.today.years_ago(1) }

# Demos:


# Cancelled accounts with active devices in them:

