
today = Date.today
tmrw = Date.today + 10.days

##########
# Quarterly MRC billing histories per rate plan
##########
def rp_rev_by_quarter
  rp_rev_by_quarter = Hash.new(0)
  (Date.today.years_ago(2)..Date.today).select { |d| d.day == 1 && d.month % 3 == 1 }.each do |qtr|
    sums = BillingHistory.where(billing_period: qtr..(qtr+3.months - 1.day)).group(:rate_plan_id).sum(:percentage)
    sums.each { |k, v| sums[k] = v.round(2) }
    quarter = "#{qtr.year}-Q#{qtr.month / 3 + 1}"
    rp_rev_by_quarter[quarter] = sums
  end
  rp_rev_by_quarter
end

hash = rp_rev_by_quarter
header = [%w(AccountName RatePlanNameId AccountActive RatePlanEnabled? MRCRate) + hash.keys + %w(TotalCurrentDevices LineTermMonths LinesInTerm LinesOutTerm RemainingMrcMonths ContractedRevenueMRCs FirstActivation)]
rep = []
RatePlan.where.not(id: [1411, 1412, 1413, 1479]).joins(:account).each do |rp|
  in_term = rp.devices.select { |d| (d.contract_end_date || today) > today }
  out_term = rp.devices.select { |d| (d.contract_end_date || tmrw) <= today }
  months_rem = (in_term.map { |d| d.contract_end_date - today}.sum.to_i) / 30
  rep << ([rp.account.account_name, rp.name_id, !rp.account.account_state.eql?('cancelled'), rp.enabled?, rp.price_mrc_data ] + hash.keys.map { |k| hash[k][rp.id].to_f * rp&.price_mrc_data.to_f } +
         [rp.devices.count, (rp.term_days / 30).round, in_term.count, out_term.count, months_rem, (months_rem * rp.price_mrc_data).round(2), rp.devices.order(:created_at).first&.created_at])
end
res = header + rep

#####
# Devices billed by Month
#####

dates = (Date.parse('2021-10-01')..Date.today).select { |d| d.day == 1 }

dates.map do |d|
  bh = BillingHistory.where.not(rate_plan_id: [1411, 1412, 1413, 1479]).where(billing_period: d)
  billed = bh.sum(:percentage).round(2)
  total = bh.where(percentage: 0.0001..1).pluck(:device_id).uniq.count
  [d, billed, total]
end

####################
# 3g revenue reporting
####################

# Verizon, Active, iccid:blank,
# Vodafone everything
dates = (Date.parse('2021-01-01')..Date.today).select { |d| d.day == 1 }
vzw_3g = Device.joins(:carrier_account).where('devices.carrier_account_id': CarrierAccount.where(carrier: Carrier.vzw).pluck(:id)).where(iccid: nil, state: 'active');0
vdf_3g = Device.joins(:carrier_account).where('devices.carrier_account_id': CarrierAccount.where(carrier: Carrier.vdf).pluck(:id)).where(state: 'active');0

dates.map do |d|
  vzw = vzw_3g.pluck(:id).reduce(0) do |sum, d_id|
    bh = BillingHistory.includes(:rate_plan).where.not(rate_plan_id: [1411, 1412, 1413, 1479]).find_by(billing_period: d, device_id: d_id)
    bh ? sum + bh.percentage * bh.rate_plan&.price_mrc_data.to_f : sum
  end
  vdf = vdf_3g.pluck(:id).reduce(0) do |sum, d_id|
    bh = BillingHistory.includes(:rate_plan).where.not(rate_plan_id: [1411, 1412, 1413, 1479]).find_by(billing_period: d, device_id: d_id)
    bh ? sum + bh.percentage * bh.rate_plan&.price_mrc_data.to_f : sum
  end
  [d, vzw, vdf]
end


  billed = bh.sum(:percentage).round(2)
