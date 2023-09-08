accounts = Account.where(id: Device.joins(:carrier, :account).where(carrier_account: Carrier.sra.first).group(:'accounts.id').pluck(:'accounts.id')) - [Account.default_account, Account.inventory_account, Account.retirement_account]
years = (Date.parse('2017-01-01')..Date.today).select { |d| d == d.beginning_of_year }

report = [['Sierra Activations Report']]
report << ['Year', 'Account', 'Total activations in year' , 'Monthly Breakdown']
years.each do |year|
  accounts.each do |a|
    devices_by_month = a.devices.joins(:carrier).where(carrier_account: Carrier.sra.first)
                        .where(last_activation_date: year.years_ago(1)..year).group('MONTH(last_activation_date)').count
    next if devices_by_month.empty?

    report << [year.year, a.account_name, (devices_by_month.sum {|x,y| y}.to_s), devices_by_month.to_a.map { |m,c| Date::MONTHNAMES[m].to_s + ':' + c.to_s }.join(' -- ')]
  end
end
