RatePlan.where(price_mrc_data: 100..1000000, carrier_id: 2)

devices = RatePlan.joins(:account, :devices).where(price_mrc_data: 100..1000000, carrier_id: 2, 'accounts.account_state': 'active').pluck(:'accounts.account_name', :'rate_plans.name', :'rate_plans.id', :'rate_plans.price_mrc_data', :'devices.device_name')

line_count = devices.count
customer_count = devices.group_by {|x| x[0]}.count
monthly_revenue = devices.sum {|x| x[3]}

