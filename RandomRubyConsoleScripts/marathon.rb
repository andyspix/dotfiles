ac = Account.where('account_name like "%maratho%"').where(account_state: 'active')
devs = ac.map { |a| a.devices }.flatten
