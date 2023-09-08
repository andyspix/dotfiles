date = Date.parse('March 5, 2023')

# purge the bad histories, and bad detail sheets
BillingHistory.where(billing_period: date.beginning_of_month).delete_all;0
DetailSheet.where(date_posted: date.end_of_month.to_time).find_each(&:destroy);0
# redo it:
BillingHistory.parallel_populate(date)
Account.find_each { |account| account.delay(run_at: Time.now + 5.hours).generate_detail_sheet_for(date.end_of_month) }
