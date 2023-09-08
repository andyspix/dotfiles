histories = PaymentHistory.where(state: 'paid', created_at: Date.parse('2022-12-01').beginning_of_day..Time.now).where(netsuite_recordno: nil, netsuite_recordid: nil)
nah = NetsuiteApiHandler.new
data = histories.map do |ph|
  ns_act_id = ph.user.account.intacct_configuration.netsuite_id
  int_id = ph.intacct_recordid
  # get everything and filter, since old invoices can be paid:
  invoices = nah.get_invoice(ns_act_id, trandate_after: Date.parse('2010-11-30'))
  [ph, invoices, invoices.select{ |inv| inv['tranid'].eql?(int_id) || inv['intacct_record_id'].eql?(int_id) } ]
end

debug_these = data.select { |d| d[2].empty? }
valid       = data.select { |d| d[2].count.eql?(1) }

matching = valid.select { |v| v[0].amount / 100.0 == (v[2].first['amount'].to_f) }
problems = valid.reject { |v| v[0].amount / 100.0 == (v[2].first['amount'].to_f) }

def payment_data(record, amount: 0, date: Date.today, reference: 'Payment via Stripe', paymentmethod: 'Credit Card - PWS')
  {
    data: {
      paymentmethod:   paymentmethod,
      reference:       reference,
      datereceived:    date.to_formatted_s(:netsuite_invoice),
      payment_details: {
        recordno: record, # Invoice record number
        amount:   amount
      }
    }
  }
end

errors = []
matching.each do |m|
  body = payment_data(m[2].first['internalid'], amount: m[2].first['amount'].to_f, date: m[0].updated_at.to_date, reference: 'Mirrored Intacct/Stripe payment')
  res = nah.post_payment(body)
  if res.match?(/Payment Created: \d\d+/)
    m[0].update netsuite_recordno: m[2].first['internalid'], netsuite_recordid: m[2].first['tranid']
  else
    errors << res
  end
end

