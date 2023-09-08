data = {}
(Date.today.beginning_of_month.months_ago(12)..Date.today.beginning_of_month.months_ago(1)).select { |d| d.day == 1 }.each do |date|
  RatePlan.where(id: BillingHistory.where(billing_period: date).pluck(:rate_plan_id).uniq).each do |rp|
    dl_dollars = InvoiceHistoriesController.data_line(rp, date, nil)&.first&.fifth.to_f
    dl_billed = InvoiceHistoriesController.data_line(rp, date, nil)&.first&.third.to_f
    all_lines = BillingHistory.where(billing_period: date, rate_plan_id: rp.id).count
    ol = InvoiceHistoriesController.overage_line(rp, date, nil)&.first&.fifth.to_f
    rc = InvoiceHistoriesController.revenue_commitment_line(rp, date, nil)&.first&.fifth.to_f
    sl = InvoiceHistoriesController.sms_line(rp, date, nil)&.first&.fifth.to_f
    rep1 = rp.commission_configuration&.rep1
    rep2 = rp.commission_configuration&.rep2
    rep1_pct = rp.commission_configuration&.rep1_pct
    rep2_pct = rp.commission_configuration&.rep2_pct
    data[date.to_s] ||= {}
    data[date.to_s][rp.id] = [all_lines, dl_billed, dl_dollars, ol, rc, sl, rep1, rep1_pct, rep2, rep2_pct]
  end
end

rep_totals = {}
data.keys.each do |date|
  data[date].each do |rp, res|
    total_count = res[0].round(2)
    total_billed = res[1].round(2)
    total_dollars = res[2..5].sum.round(2)
    rep_totals[res[6]] ||= {}
    rep_totals[res[8]] ||= {}
    rep_totals[res[6]][date] ||= [0,0,0]
    rep_totals[res[8]][date] ||= [0,0,0]

    rep_totals[res[6]][date][2] += total_dollars * res[7].to_f / 100
    rep_totals[res[8]][date][2] += total_dollars * res[9].to_f / 100
    rep_totals[res[6]][date][2] = rep_totals[res[6]][date][2].round(2)
    rep_totals[res[8]][date][2] = rep_totals[res[8]][date][2].round(2)

    rep_totals[res[6]][date][1] += total_billed * res[7].to_f / 100
    rep_totals[res[8]][date][1] += total_billed * res[9].to_f / 100
    rep_totals[res[6]][date][1] = rep_totals[res[6]][date][1].round(2)
    rep_totals[res[8]][date][1] = rep_totals[res[8]][date][1].round(2)

    rep_totals[res[6]][date][0] += total_count * res[7].to_f / 100
    rep_totals[res[8]][date][0] += total_count * res[9].to_f / 100
    rep_totals[res[6]][date][0] = rep_totals[res[6]][date][0].round(2)
    rep_totals[res[8]][date][0] = rep_totals[res[8]][date][0].round(2)
  end
end

totals_csv = [['Rep', 'Month', 'TotalLines', 'BilledMRCs', 'TotalRevenue']]
rep_totals.each do |rep, date_h|
  date_h.each do |date, total_ar|
    totals_csv << [rep || 'null', date, *total_ar]
  end
end


rep_details = {}
data.keys.each do |date|
  data[date].each do |rp, res|
    name_id = RatePlan.find(rp).name_id
    total_count = res[0].round(2)
    total_billed = res[1].round(2)
    total_dollars = res[2..5].sum.round(2)
    rep_details[res[6]] ||= {}
    rep_details[res[8]] ||= {}
    rep_details[res[6]][date] ||= []
    rep_details[res[8]][date] ||= []
    #res[7].to_f.positive? && rep_details[res[6]][date].push("#{(total_dollars * res[7].to_f / 100).round(2)} == #{name_id}")
    #res[9].to_f.positive? && rep_details[res[8]][date].push("#{(total_dollars * res[9].to_f / 100).round(2)} == #{name_id}")
    res[7].to_f.positive? && rep_details[res[6]][date].push([name_id, (total_count * res[7].to_f / 100).round(2), (total_billed * res[7].to_f / 100).round(2), (total_dollars * res[7].to_f / 100).round(2)])
    res[7].to_f.positive? && rep_details[res[8]][date].push([name_id, (total_count * res[9].to_f / 100).round(2), (total_billed * res[9].to_f / 100).round(2), (total_dollars * res[9].to_f / 100).round(2)])
  end
end

details_csv = [['Rep', 'Month', 'RatePlan (Id)', 'TotalLines', 'BilledMRCs', 'TotalRevenue']]
rep_details.each do |rep, date_h|
  date_h.each do |date, name_totals_ar|
    name_totals_ar.each do |line|
      details_csv << [rep || 'null', date, *line]
    end
  end
end


# OVG/USAGE/PPU Report
bytes_hash = BillingHistory.where(billing_period: Date.today.beginning_of_year.years_ago(1)..Date.today).group(:rate_plan_id, :billing_period).sum(:bytes_used)
devices_hash = BillingHistory.where(billing_period: Date.today.beginning_of_year.years_ago(1)..Date.today).group(:rate_plan_id, :billing_period).sum(:percentage)
rp_hash = RatePlan.joins(:carrier_account).pluck(:id, :name, :mrc_data, :ovg_data_unit, :price_ovg_data_unit, :'carrier_accounts.carrier_account_name').map { |x,y,z,a,b,c| [x,[y,z,a,b,c]] }.to_h

rps = devices_hash.map { |k, v| k[0] }.uniq
dates = devices_hash.map { |k, v| k[1] }.uniq

report = [['RatePlanName', 'CarrierAccount', 'BillingPeriod', 'BilledDevices', 'DataUsed', 'PoolAllowance', 'OverageUsed', 'OverageDataUnit', 'OveragePrice']]
rps.each do |rp|
  dates.each do |date|
    bytes = bytes_hash[[rp, date]].to_f
    devs = devices_hash[[rp, date]].to_f.round(2)
    allowance = rp_hash[rp][1].to_f * devs
    report << [rp_hash[rp][0], rp_hash[rp][4], date.to_date, devs, bytes, allowance, [0, bytes - allowance].max, rp_hash[rp][2], rp_hash[rp][3]]
  end
end


