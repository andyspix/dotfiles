date = Date.today.months_ago(1)
range =  date.beginning_of_month..date.end_of_month
devs = CommissionHistory.where(issued_on: range, state: 'chargeback').pluck(:device_id).uniq

header = ['Device'] + ['RatePlanName', 'issued_on', 'issued_to', 'state'] * 8
rep = devs.map do |d|
  [ Device.find(d).device_name,
    *CommissionHistory.where(device_id: d).order(id: :asc).map { |c| [c.rate_plan.name, c.issued_on, c.issued_to, c.state ] }.flatten
  ]
end;0

tmp_csv([header] + rep)

