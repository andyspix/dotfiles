dates = (Date.parse('2020-12-01')..Date.parse('2021-11-01')).select { |d| d.day == 1 }
account_ids = BillingHistory.where(billing_period: dates).distinct.pluck(:account_id).compact

rep = [['account + field', *dates]]
Account.where(id: account_ids).order(account_name: :asc).find_each do |ac|
  line = ["#{ac.account_name} - TotalLines"]
  dates.each do |date|
    devs = BillingHistory.where(account_id: ac.id, billing_period: date).group(:device_id).count.count
    line += [devs]
  end
  rep << line
end

rep << ['']
rep << ['']

Account.where(id: account_ids).order(account_name: :asc).find_each do |ac|
  line = ["#{ac.account_name} - BilledLines"]
  dates.each do |date|
    devs = BillingHistory.where(account_id: ac.id, billing_period: date).sum(:percentage).round(1)
    line += [devs]
  end
  rep << line
end

rep << ['']
rep << ['']

Account.where(id: account_ids).order(account_name: :asc).find_each do |ac|
  line = ["#{ac.account_name} - NetNewLines"]
  dates.each do |date|
    devs = BillingHistory.where(account_id: ac.id, billing_period: date).group(:device_id).count.count
    devs_prior = BillingHistory.where(account_id: ac.id, billing_period: date.months_ago(1)).group(:device_id).count.count
    line += [devs - devs_prior]
  end
  rep << line
end

rep << ['']
rep << ['']

deact_hash = AssignmentChangeHistory.where(account: Account.retirement_account).group('YEAR(created_at)', 'MONTH(created_at)', :previous_account_id).count
Account.where(id: account_ids).order(account_name: :asc).find_each do |ac|
  line = ["#{ac.account_name} - DeactivatedLines"]
  dates.each do |date|
    line += [deact_hash[[date.year, date.month, ac.id]] || 0]
  end
  rep << line
end


tmp_csv rep




