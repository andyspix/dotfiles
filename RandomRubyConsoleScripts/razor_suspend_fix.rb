source '/tmp/razors'
ids = ds.pluck(:id)
BillingHistory.where(billing_period: '2020-07-01', device_id: ids).count
BillingHistory.where(billing_period: '2020-07-01', device_id: ids).destroy_all
current_states = ds.map { |d| d.state_change_histories.last.created_at }
previous_states = ds.map { |d| d.state_change_histories.last(2).first.created_at }
# These should be just 2 of each, if so, delete the histories
previous_states.group_by { |x| Date.parse(x.to_s) }.keys
current_states.group_by { |x| Date.parse(x.to_s) }.keys
# delete-em
ds.each { |d| d.state_change_histories.order(id: :desc).limit(2).destroy_all }
# Re-bill
date = Date.today.months_ago(1)
Account.find(816).detail_sheets.last.destroy

ds.pluck(:id).each { |d_id| BillingHistory.populate(date, device_id: d_id) }
Account.find(816).generate_detail_sheet_for(date.end_of_month)
