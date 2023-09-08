
# Simple Report for Gregg/Christie
dates = (Date.parse('2022-01-01')..Date.today).select { |d| d.day == 1 }
res = dates.map do |d|
  bh = BillingHistory.where.not(rate_plan_id: [1411, 1412, 1413, 1479]).where(billing_period: d)
  total = bh.where(percentage: 0.0001..1).pluck(:device_id).uniq.count
  billed = bh.sum(:percentage).round(2)
  [d, total, billed]
end
report = [['Date', 'TotalBilledLines', 'BilledMRCs']] + res

# Spreadsheet for Excel graphing of lines by account - sent to Derrick
res = dates.map do |d|
  bh = BillingHistory.where.not(rate_plan_id: [1411, 1412, 1413, 1479]).where(billing_period: d)
  ac_totals = bh.where(percentage: 0.0001..1).group(:account_id).count
  [d, ac_totals]
end

acts = Set.new()
res.each { |r| acts += r[1].keys }
res_hash = res.to_h
act_map = acts.map { |a| [a, Account.find(a)] }.to_h

report = [['Account', 'IntacctId', *dates.map(&:to_s)]] +
acts.map do |act|
  a = act_map[act] || act
  line = [a.account_number_name, a.intacct_configuration&.intacct_customerid]
  dates.each { |date| line += [res_hash[date][act]] }
  line
end

