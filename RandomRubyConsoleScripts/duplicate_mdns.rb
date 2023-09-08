mdns = Device.group(:mdn).count.select { |x,y| y > 1 }.to_a.map(&:first) - [nil]
problems = mdns.select { |m| Device.joins(:account).where(mdn: m).where.not('accounts.id': Account.special_accounts.pluck(:id)).count > 1 }
report = problems.map { |mdn| [mdn, Device.joins(:account).where(mdn: mdn).where.not('accounts.id': Account.special_accounts.pluck(:id)).pluck( :'accounts.account_name', :device_name)].flatten.uniq}
