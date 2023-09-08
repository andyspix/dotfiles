date1 = Date.today.months_ago(1)
date1 -= (date1.day - 5) # set to 5th day of month
date2 = Date.today.months_ago(2)
date2 -= (date2.day - 5) # set to 5th day of month
date3 = Date.today.months_ago(3)
date3 -= (date3.day - 5) # set to 5th day of month
date4 = Date.today.months_ago(4)
date4 -= (date4.day - 5) # set to 5th day of month

# purge the bad histories, bad invoices, and bad detail sheets
#BillingHistory.where(billing_period: date1.beginning_of_month).delete_all;0
#Invoice.where(billing_period_start: date1.beginning_of_month).find_each(&:destroy);0
#DetailSheet.where(date_posted: date1.end_of_month).find_each(&:destroy);0
#
#BillingHistory.where(billing_period: date2.beginning_of_month).delete_all;0
#Invoice.where(billing_period_start: date2.beginning_of_month).find_each(&:destroy);0
#DetailSheet.where(date_posted: date2.end_of_month).find_each(&:destroy);0
#
#BillingHistory.where(billing_period: date3.beginning_of_month).delete_all;0
#Invoice.where(billing_period_start: date3.beginning_of_month).find_each(&:destroy);0
#DetailSheet.where(date_posted: date3.end_of_month).find_each(&:destroy);0
#
#BillingHistory.where(billing_period: date4.beginning_of_month).delete_all;0
#Invoice.where(billing_period_start: date4.beginning_of_month).find_each(&:destroy);0
#DetailSheet.where(date_posted: date4.end_of_month).find_each(&:destroy);0
#
# redo it:
#Device.pluck(:id).each { |d_id| BillingHistory.populate(date4, device_id: d_id) };0
#Device.pluck(:id).each { |d_id| BillingHistory.populate(date3, device_id: d_id) };0
#Device.pluck(:id).each { |d_id| BillingHistory.populate(date2, device_id: d_id) };0
#Device.pluck(:id).each { |d_id| BillingHistory.populate(date1, device_id: d_id) };0

#Account.find_each do |account|
  #if Invoice.find_by(account_id: account.id, billing_period_start: date4.beginning_of_month).nil? && !account.rate_plans.empty?
  #  Invoice.create(Invoice.generate(account.id, date4))
  #end
  #if Invoice.find_by(account_id: account.id, billing_period_start: date3.beginning_of_month).nil? && !account.rate_plans.empty?
  #  Invoice.create(Invoice.generate(account.id, date3))
  #end
  #if Invoice.find_by(account_id: account.id, billing_period_start: date2.beginning_of_month).nil? && !account.rate_plans.empty?
  #  Invoice.create(Invoice.generate(account.id, date2))
  #end
  #if Invoice.find_by(account_id: account.id, billing_period_start: date1.beginning_of_month).nil? && !account.rate_plans.empty?
    #Invoice.create(Invoice.generate(account.id, date1))
  #end
#end

csv_june_a = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/original2_csvs/intacct_summary_June_2020.csv'
csv_july_a = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/original2_csvs/intacct_summary_July_2020.csv'
csv_aug_a = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/original2_csvs/intacct_summary_August_2020.csv'
csv_sept_a = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/original2_csvs/intacct_summary_September_2020.csv'
csv_june_b = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/fixed_csvs/intacct_summary_June_2020.csv'
csv_july_b = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/fixed_csvs/intacct_summary_July_2020.csv'
csv_aug_b = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/fixed_csvs/intacct_summary_August_2020.csv'
csv_sept_b = read_csv '/Users/andyspix/random_ruby_console_scripts/billing_debug/fixed_csvs/intacct_summary_September_2020.csv'

def sum_charges(account, csv)
  charges = 0
  return 0 if csv.nil?
  csv.each { |row| charges += row['Amount'].to_f if row['PwsAccountNumberName'] == account }
  charges
end

accounts =
(csv_june_a['PwsAccountNumberName'] +
csv_july_a['PwsAccountNumberName'] +
csv_aug_a['PwsAccountNumberName'] +
csv_sept_a['PwsAccountNumberName'] +
csv_june_b['PwsAccountNumberName'] +
csv_july_b['PwsAccountNumberName'] +
csv_aug_b['PwsAccountNumberName'] +
csv_sept_b['PwsAccountNumberName'] ).uniq
report = [['Customer', 'June (org)', 'June (new)', 'July (org)', 'July (new)', 'August (org)', 'August (new)', 'September (org)', 'September (new)', 'June Delta', 'July Delta', 'August Delta', 'September Delta']]

accounts.each do |ac|
  jun_a = sum_charges(ac, csv_june_a)
  jun_b = sum_charges(ac, csv_june_b)
  jul_a = sum_charges(ac, csv_july_a)
  jul_b = sum_charges(ac, csv_july_b)
  aug_a = sum_charges(ac, csv_aug_a)
  aug_b = sum_charges(ac, csv_aug_b)
  sep_a = sum_charges(ac, csv_sept_a)
  sep_b = sum_charges(ac, csv_sept_b)
  report << [ac, jun_a, jun_b, jul_a, jul_b, aug_a, aug_b, sep_a, sep_b, jun_a - jun_b, jul_a - jul_b, aug_a - aug_b, sep_a - sep_b]
end

######################
######################
report = [['Customer', 'June (org)', 'june-delta', 'June fix', 'July (org)', 'July fix', 'july-delta', 'August (org)', 'August fix', 'august-delta', 'September (org)' ]]

accounts.each do |ac|
  jun_a = sum_charges(ac, csv_june_a)
  jun_b = sum_charges(ac, csv_june_b)
  jul_a = sum_charges(ac, csv_july_a)
  jul_b = sum_charges(ac, csv_july_b)
  aug_a = sum_charges(ac, csv_aug_a)
  aug_b = sum_charges(ac, csv_aug_b)
  sep_a = sum_charges(ac, csv_sept_a)
  report << [ac, jun_a, jun_b, jun_b-jun_a, jul_a, jul_b, jul_b-jul_a, aug_a, aug_b, aug_b-aug_a, sep_a]
end

tmp_csv(report)
