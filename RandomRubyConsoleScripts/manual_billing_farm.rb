date = Date.parse('Tue, 05 Jul 2022')


# Repeat until done on 6 parallel machines
lacking_history = (Device.pluck(:id) - BillingHistory.where(billing_period: 'Fri, 01 Jul 2022').pluck(:device_id)).sort
lacking_history[0..9999].each { |x| BillingHistory.populate(date, device_id: x) }
lacking_history[10000..19999].each { |x| BillingHistory.populate(date, device_id: x) }
lacking_history[20000..29999].each { |x| BillingHistory.populate(date, device_id: x) }
lacking_history[30000..39999].each { |x| BillingHistory.populate(date, device_id: x) }
lacking_history[40000..49999].each { |x| BillingHistory.populate(date, device_id: x) }
lacking_history[50000..59999].each { |x| BillingHistory.populate(date, device_id: x) }

# Generate legacy invoice models:
Account.find_each do |account|
  if Invoice.find_by(account_id: account.id, billing_period_start: date.beginning_of_month).nil? && !account.rate_plans.empty?
    Invoice.create(Invoice.generate(account.id, date))
  end
end

# queue detail sheets:
Account.find_each { |account| account.delay.generate_detail_sheet_for(date.end_of_month)}
