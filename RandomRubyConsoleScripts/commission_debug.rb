Device.where(created_at: Date.parse('Jan 1, 2021')..Date.parse('feb 1, 2021')).group('Date(created_at)').count
#    Fri, 22 Jan 2021 => 55,
#    Sat, 23 Jan 2021 => 1,
#    Mon, 25 Jan 2021 => 238,
#    Tue, 26 Jan 2021 => 647,
#    Wed, 27 Jan 2021 => 257,
#    Thu, 28 Jan 2021 => 36,
#    Fri, 29 Jan 2021 => 280,
#    Sat, 30 Jan 2021 => 43,
#    Sun, 31 Jan 2021 => 137

# Release code, then:
CommissionHistory.where(amount: -1000000..-0.001).update_all state: 'chargeback'

res = CommissionHistory.group('Date(issued_on)').count
CommissionHistory.where(issued_on: Date.parse('Sun, 14 Mar 2021')..Date.parse('Wed, 31 Mar 2021')).destroy_all
CommissionHistory.daily_rollup(Date.parse('Mon, 29 Mar 2021'))

res = CommissionHistory.group('Date(issued_on)').count
CommissionHistory.where(issued_on: Date.parse('Thu, 1 Apr 2021')..Date.parse('Thu, 22 Apr 2021')).destroy_all
CommissionHistory.daily_rollup(Date.parse('Fri, 17 Apr 2021'))

## retro payment of term override payments
ccs = CommissionConfiguration.where.not(term_override: nil)
issues = ccs.reject { |c| c.commission_histories.count.zero? }

ap issues.map { |cc| [cc.id, cc.commission_histories.count].join(' : ') }

hund = issues.where(rep1_pct: 100)

results = {}
issues.each do |i|
  extra = ( i.term_override / i.rate_plan.term_days - 1 )
  i.commission_histories.where(created_at: Date.today.days_ago(1000).. (Date.parse('March 1, 2021'))).each do |ch|
    results[ch.issued_to] ||= {}
    results[ch.issued_to][i.rate_plan.name_id] ||= 0
    results[ch.issued_to][i.rate_plan.name_id] += (ch.amount * extra).round(2)
  end
end



