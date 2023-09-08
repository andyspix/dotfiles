# Delete the bad histories and invoices
date = Date.parse('March 5, 2022').months_ago(1)
Invoice.where(billing_period_start: date.beginning_of_month).destroy_all;0
DetailSheet.where(date_posted: date.end_of_month).destroy_all;0
BillingHistory.where(billing_period: date.beginning_of_month).destroy_all;0
IntacctInvoiceHistory.where(date_posted: 'Feb 07 2022').destroy_all;0
# TODO: Need to delete the activation histories as well...
# TODO: Need to delete the TRM Charge histories as well...

#Verizon fixes it's shit - doneish

# repopulate old SMS values w/ VZW API

# update the February monthly usages
MonthlyDataUsage.aggregate_ddu_to_mdu(Device.where(carrier_account: 1).pluck(:id), Date.parse('2022-02-01'))
MonthlyDataUsage.aggregate_ddu_to_mdu(Device.where(carrier_account: 3).pluck(:id), Date.parse('2022-02-01'))
MonthlyDataUsage.aggregate_ddu_to_mdu(Device.where(carrier_account: 2).pluck(:id), Date.parse('2022-02-01'))
MonthlyDataUsage.aggregate_ddu_to_mdu(Device.where(carrier_account: 4).pluck(:id), Date.parse('2022-02-01'))
MonthlyDataUsage.aggregate_ddu_to_mdu(Device.where(carrier_account: 9).pluck(:id), Date.parse('2022-02-01'))

# Repopulate histories
date = Date.today.months_ago(1)
Device.pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) }




# Regenerate Invoices
Account.find_each do |account|
  if Invoice.find_by(account_id: account.id, billing_period_start: date.beginning_of_month).nil? && !account.rate_plans.empty?
    Invoice.create(Invoice.generate(account.id, date))
  end
end

# Scrub and replace the detail sheets:
Account.find_each do |account|
  account.delay.generate_detail_sheet_for(date.end_of_month)
end

# Generate the Intacct CSV again, DO NOT Upload anything for POLYMATH ROBOTICS
