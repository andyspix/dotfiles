# STEPS
# move all the AT&T greenlots lines back into the original rate plan
# remove last 2 assignment change histories for each moved device
# Put all contract end dates back in place for any of the moved lines
# Find and remove all commissions paid to those lines in the last 2-weeks and any chargebacks for prior commission histories on those lines
# Deploy the roaming code
# Create roaming usages for all lines before Wednesday end of day


# Current RatePlan
# Original RatePlan
#
ac = Account.find(140)
inv = RatePlan.inventory
org_rp = RatePlan.find(2270)
bad_rp = RatePlan.find(2502)

# Figure out what was moved to where from where:
bad_rp.devices.map { |x| x.assignment_change_histories.pluck(:previous_rate_plan_id, :rate_plan_id) }.uniq

# Save the list of IDs to iterate multiple operations as needed
devs = bad_rp.devices.pluck(:id)

# This undoes any commissions fuckup-ery from the moves
# 1. get a list of all commission events impacted by this tomfoolery
ch_hash = CommissionHistory.where(device_id: devs).group(:device_id).count

# 2. Simply destroy any 'commissions' to the roaming plan
CommissionHistory.where(device_id: ch_hash.keys, rate_plan_id: bad_rp.id).destroy_all

# 3. Fix any chargebacks that remain
CommissionHistory.where(device_id: ch_hash.keys, rate_plan_id: org_rp.id, state: 'chargeback', amount: -1000..0).destroy_all
CommissionHistory.where(device_id: ch_hash.keys, rate_plan_id: org_rp.id, state: 'chargeback', amount: 0..1000).update_all state: 'active'

# This puts the devices into the original rate plans, and clears up contract dates and assignment histories for billing
Device.where(id: devs).each do |d|
  prev_rp = RatePlan.find d.assignment_change_histories.last.previous_rate_plan_id
  d.rate_plan = prev_rp
  d.save
  d.contract_end_date = d.contract_end_date - 2.weeks
  d.save
  d.assignment_change_histories.last(2).each(&:delete)
end

# Nuke the 'roaming' rate plan
bad_rp.unlock_rate_plan
bad_rp.destroy

