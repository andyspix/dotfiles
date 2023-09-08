res = Account.needs_billing.map { |a| x = a.estimated_bill(Date.today.months_ago(1), true); y = a.invoice_histories.last&.total_due; [a.id, x, x[:total], y] }
res2 = res.reject { |x| x[3].nil? || x[3].zero? }.select { |x, y, z, w| ((z - w).abs / w) > 0.5 }
res3 = res2.map { |x| [Account.find(x[0]).account_name, x[2], x[3]] }

Account.find(1079).estimated_bill Date.today.months_ago(1), true

# Accounts where Fast != Slow as of Feb 8th
res = Account.needs_billing.select { |x| x.estimated_bill(Date.today, true) != x.estimated_bill(Date.today, false) }
quick = res.select { |a| a.devices.count < 500 }
slow = res - quick
quick_data = quick.map { |x| [x, x.estimated_bill(Date.today, true),  x.estimated_bill(Date.today, false)] }
inspect = quick_data.map { |x| [x[0], x[1][:total], x[2][:total]] }.reject { |x| (x[1] - x[2]).abs < 500 }

# Accounts where Fast >> Last Month
res.last
accts = Account.needs_billing.reject { |x| x.invoice_histories.empty? }
accts
# Accounts where Slow >> Last Month

