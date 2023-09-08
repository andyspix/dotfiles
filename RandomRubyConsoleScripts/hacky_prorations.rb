end_of_cycle = Date.today.months_ago(1).end_of_month

# Prorate 0 usage Miller
bp = BillingHistory.last.billing_period
rp = RatePlan.find(1689)
miller_devs = MonthlyDataUsage.where(device_id: rp.devices.pluck(:id), date_for: Date.today.beginning_of_month.months_ago(1), bytes_used: 1..10000000000000000)
miller_0_devs = rp.devices.pluck(:id) - miller_devs
DetailSheet.where(account_id: rp.account.id).last.destroy
BillingHistory.where(billing_period: bp, device_id: miller_0_devs).update_all percentage: 0
rp.account.generate_detail_sheet_for(end_of_cycle)

# Prorate Volta fully
bp = BillingHistory.last.billing_period
rp = RatePlan.find(1417)
volta_devs = rp.devices.pluck(:id)
DetailSheet.where(account_id: rp.account.id).last.destroy
BillingHistory.where(billing_period: bp, device_id: volta_devs).update_all rate_plan_id: rp.id, rate_plan_name: rp.name
rp.account.generate_detail_sheet_for(end_of_cycle)

# Move Swiftmile into 1GB
bp = BillingHistory.last.billing_period
rp = RatePlan.find(2025)
swiftm_devs = rp.devices.pluck(:id)
DetailSheet.where(account_id: rp.account.id).last.destroy
BillingHistory.where(billing_period: bp, device_id: swiftm_devs).update_all rate_plan_id: rp.id, rate_plan_name: rp.name
rp.account.generate_detail_sheet_for(end_of_cycle)

# Remove and redo detail sheets for these 3
