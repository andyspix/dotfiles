ac_pub = Account.find(70)
ac_priv = Account.new(ac_pub.attributes)
ac_priv.id = nil
ac_priv.account_name = 'Econolite-Private'
ac_priv.save

ac_pub.account_name = 'Econolite-Public'
ac_pub.save

RatePlan.find(110).update_attribute :account_id, ac_priv.id

BillingHistory.where(rate_plan_id: 110).update_all account_id: ac_priv.id

(1..24).to_a.reverse_each do |i|
  Invoice.create(Invoice.generate(1015, Date.today.months_ago(i)))
  ac_priv.generate_detail_sheet_for(Date.today.months_ago(i).end_of_month)
  sleep 1
end

result = []
(1..24).to_a.reverse_each do |i|
  result << Account.write_intacct_csv(Date.today.months_ago(i))
end
