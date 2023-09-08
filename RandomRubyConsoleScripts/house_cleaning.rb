# Accounts with no users
#
active = Account.where(account_state: 'active')
no_users = Account.where.not(id: User.pluck(:account_id).uniq)
active_no_users = no_users.where(account_state: 'active')
active_no_devices = Account.where(id: active.select{ |ac| ac.devices.empty? }.map(&:id))

db_and = active_no_devices.map{ |ac| [ac.account_name, ac.deletion_blockers] }

active_devices_in_unbilled_accounts

account_counts = Account.group(:account_state).count
{"active"=>766, "cancelled"=>257, "demo"=>78, "nonpayment-hold"=>1, "not-billed-misc"=>140, "prepaid"=>4}

# Cancel active accounts with no devices created prior to 2021
