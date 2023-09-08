CommissionHistory.delete_all
sept = Date.parse('01-10-2020').days_ago(1)
date = sept

# release seed_settled_commissions changes
# Should result in ~332k settled commissions
CommissionHistory.seed_settled_commissions(sept);0

rp_map = {}
csv = read_csv('/Users/andyspix/random_ruby_console_scripts/commission_import.csv')
csv.each { |x,y| rp_map[x[1].to_i] = y[1].to_i }
roevic_map = rp_map.reject { |k,v| v.zero? }

history_map = CommissionHistory.group(:rate_plan_id).count

all_keys = (history_map.keys + roevic_map.keys).uniq.sort

# in roevic_map but not histories
# roevic_map.keys.select { |k| roevic_map[k] != history_map[k] }
# in history_map but not rp
# history_map.keys.select { |k| roevic_map[k] != history_map[k] }

merge_map = [['rate_plan', 'id', 'account_state', 'roevic', 'histories', 'delta']]
all_keys.each do |k|
  rp = RatePlan.find(k)
  merge_map << [rp.name, rp.id, rp.account.account_state, roevic_map[k], history_map[k], roevic_map[k].to_i - history_map[k].to_i]
end

# Assuming the Maps look, "okay" we'll want to generate new commission payments as of the end of October:
CommissionHistory.generate_new(sept + 31.days)

# Then look at the Active/billable histories vs. activation counts in the month


################## Don't overpay:
#



