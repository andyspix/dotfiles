pcc = Account.find(270).public_cost_centers.first
dates = [Date.parse('Nov 23, 2018'), Date.parse('Dec 23, 2018'), Date.parse('Jan 23, 2019'), Date.parse('Feb 23, 2019'), Date.parse('Mar 23, 2019'), Date.parse('Apr 23, 2019')]
result = [['wireless_number', 'ip_address', *dates]]
wns = pcc.public_billing_datum.where(billing_cycle_date: dates).pluck(:wireless_number).uniq

wns.each do |wn|
  arr = [wn]
  dates.each_with_index do |bcd, i|
    pbd = PublicBillingDatum.find_by(wireless_number: wn, billing_cycle_date: bcd)
    if pbd.nil?
      arr.append nil
    else
      arr.append pbd.static_ip_address if i.zero?
      a = pbd.billable?
      b = pbd.billable_1048?
      if a == b
        arr.append a
      else
        arr.append 'ERROR'
      end
    end
  end
  result << arr
end


##############
################
# Missing data in detail sheets?
# ############
# ##############

Account.find(270).devices.count
Device.find(431895)

