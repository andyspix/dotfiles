def rp_friendly(rp)
  [rp.plan_identifier, rp.description].join(' :: ')
end

def gen_report(date=Date.today.months_ago(1))
  range = date.beginning_of_month..date.end_of_month
  new_users = User.where(created_at: range)
  new_accounts = Account.where(created_at: range)
  new_rate_plans = RatePlan.where(created_at: range)
  new_devices = Device.where(created_at: range)
  new_contracts = DocusignNotification.where(implemented: true, created_at: range)

  File.open('/tmp/roevic_report.txt', 'w') do |file|
    file.puts "### New Activity: #{range}"
    file.puts "### Completed Contracts: #{new_contracts.count}"
    file.puts "### New Accounts: #{new_accounts.count}"
    file.puts new_accounts.map { |ac| ac.account_number_name }
    file.puts "### New RatePlans: #{new_rate_plans.count}"
    file.puts new_rate_plans.map { |rp| rp_friendly(rp) }
    file.puts "### New Devices: #{new_devices.count}"
    file.puts new_devices.joins(:rate_plan).group('rate_plans.id').count.sort_by{ |k,v| -v }.map { |k,v| "#{v} => #{rp_friendly(RatePlan.find(k))}" }
  end

  puts 'written to /tmp/roevic_report.txt'
end
