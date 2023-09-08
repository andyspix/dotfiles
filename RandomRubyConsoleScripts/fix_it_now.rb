#Import the missing assignment histories
AssignmentChangeHistory
stuff = YAML.load(File.read('/tmp/missing_achs'))
valid = stuff.select(&:valid?)
if (valid.count == stuff.count) 
  stuff.each { |s| AssignmentChangeHistory.create s.attributes }
end
AssignmentChangeHistory.where(rate_plan_id: 53).update_all(rate_plan_id: 1411)
AssignmentChangeHistory.where(previous_rate_plan_id: 53).update_all(previous_rate_plan_id: 1411)

# Delete the bad histories and invoices
date = Date.parse('May 5, 2019').months_ago(1)
BillingHistory.where(billing_period: date.beginning_of_month).destroy_all;0
Invoice.where(billing_period_start: date.beginning_of_month).destroy_all;0

########### Parallel on local:
# Device.where(id: (0..184795)).pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) }
# Device.where(id: (184796..269795)).pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) }
# Device.where(id: (269796..1000000)).pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) }
########### Flat on Production:
Device.pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) } # TODO: Currently running, invoices next

Account.find_each do |account|
  if Invoice.find_by(account_id: account.id, billing_period_start: date.beginning_of_month).nil? && !account.rate_plans.empty?
    Invoice.create(Invoice.generate(account.id, date))
  end
end

# Scrub and replace the detail sheets:
DetailSheet.where(date_posted: date.end_of_month).destroy_all;0
Account.find_each do |account|
  account.delay.generate_detail_sheet_for(date.end_of_month)
end

