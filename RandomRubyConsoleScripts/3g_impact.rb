feb = Date.parse('feb 1 2023')
jan = Date.parse('jan 1 2023')
dec = Date.parse('dec 1 2022')
febs_0 = BillingHistory.where(billing_period: feb).where(percentage: 0).pluck(:device_id); 0
jans_n0 = BillingHistory.where(billing_period: jan).where.not(percentage: 0).pluck(:device_id); 0
jans_0 = BillingHistory.where(billing_period: jan).where(percentage: 0).pluck(:device_id); 0
decs_n0 = BillingHistory.where(billing_period: dec).where.not(percentage: 0).pluck(:device_id); 0

was_some_now_none_jan = Set.new(jans_0) & Set.new(decs_n0); 0
was_some_now_none_feb = Set.new(febs_0) & Set.new(jans_n0); 0

three_gee_impacts_jan = Device.where(id: was_some_now_none_jan).select { |d| d.iccid.blank? }
three_gee_impacts_feb = Device.where(id: was_some_now_none_feb).select { |d| d.iccid.blank? }

three_gee_impacts_jan.count
three_gee_impacts_feb.count
three_gee_impacts_jan.sum { |d| d.billing_histories.for(dec).take.rate_plan.price_mrc_data }.to_f
three_gee_impacts_feb.sum { |d| d.billing_histories.for(jan).take.rate_plan.price_mrc_data }.to_f
# _.sum { |x, y| y } == 17,616.55
#

# Others
Device.where(id: (was_some_now_none - three_gee_impacts.pluck(:id))).map { |d| [d.device_name, d.rate_plan.price_mrc_data] }
# _.sum { |x, y| y } == 27,595.70
#

