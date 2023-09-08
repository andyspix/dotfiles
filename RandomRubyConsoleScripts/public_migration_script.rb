# Device.find_by(device_name: 89148000003477734227)

# Sanity check that all public are in the staging account:
public_count = Device.where(carrier_account_id: 9).count
# How many devices are we migrating? - 25k-ish
pre_count = Account.find(2).devices.count
pre_list = Account.find(2).devices.pluck :device_name; 0

last_rp_before = RatePlan.last.id
## Make Rate Plans for all cost centers that are linked to accounts
(PublicCostCenter.all - PublicCostCenter.unlinked).each{ |pc| pc.assign_devices_to_rate_plan(Date.parse('April 23, 2019') }

# Test movement expectations - 772 post count
post_count = Account.find(2).devices.count
post_list = Account.find(2).devices.pluck :device_name; 0

# moved_count 24334
moved_count = RatePlan.where('name like "%:: VZWPublic ::%"').map { |rp| rp.devices.count }.sum

# off by one?
moved_count + post_count == pre_count

# Remove all newly createad but empty RatePlans
RatePlan.where(id: RatePlan.where('name like "%:: VZWPublic ::%"').select { |rp| rp.devices.count.zero? }.map(&:id)).destroy_all

# Add Test Ready mode to 2 special cost centers
PublicCostCenter.find(AccountPublicCostCenter.where(account_id: 270).pluck(:public_cost_center_id)).each { |pcc| pcc.rate_plan&.add_trm_to_plan(0) }
PublicCostCenter.find(AccountPublicCostCenter.where(account_id: 497).pluck(:public_cost_center_id)).each { |pcc| pcc.rate_plan&.add_trm_to_plan(0) }

# Make sure to adjust assignment history date to the end of the 23rd
assign_date = Date.parse('April 24, 2019')
active_date = Date.parse('Jan 1, 2019')
RatePlan.where("id > ?", last_rp_before).find_each do |rp| 
  rp.devices.find_each do |dev|
    # Assignments:
    ash = dev.assignment_change_histories.last
    ash.created_at = assign_date
    ash.save

    # Activation Charges
    ach = ActivationChargeHistory.find_or_initialize_by(account_id: dev.account.id, device_id: dev.id)
    ach.created_at = active_date
    ach.save
  end
end

# CSV mapping:
def read_csv(infile)
  require 'csv'
  quote_chars = %w(" | ~ ^ & *)
  begin
    csv_text = File.open(infile, 'r:bom|utf-8')
    CSV.parse(csv_text, headers: true, quote_char: quote_chars.shift, liberal_parsing: true)
  rescue CSV::MalformedCSVError
    quote_chars.empty? ? raise : retry
  end
end
csv = read_csv('/Users/andyspix/Downloads/Devices_05072019_184200.csv')
hashmap1 = csv.map{ |c| [c['MEID'], c['Cost Center Code']] }.to_h
hashmap2 = csv.map{ |c| [c['ESN'], c['Cost Center Code']] }.to_h
hashmap3 = csv.map{ |c| [c['ICCID'], c['Cost Center Code']] }.to_h
all_devs = CarrierAccount.find(9).devices;0
filter1 = all_devs.reject{ |d| hashmap1.key? d.device_name };0
filter2 = filter1.reject{ |d| hashmap2.key? d.device_name };0
filter3 = filter2.reject{ |d| hashmap3.key? d.device_name };0
meid_mapped = all_devs - filter1;0
esn_mapped = filter1 - filter2;0
iccid_mapped = filter2 - filter3;0
tbd_mapped = filter3;0
meid_mapped_moved = []
esn_mapped_moved = []
iccid_mapped_moved = []
(PublicCostCenter.all - PublicCostCenter.unlinked).each{ |pc| pc.create_migrated_rate_plan };0

meid_mapped.each do |d| 
  pcc = PublicCostCenter.find_by(cost_center: hashmap1[d.meid])
  next if pcc.blank?
  next if pcc.rate_plan.nil?

  d.rate_plan = pcc.rate_plan
  meid_mapped_moved << d
end

esn_mapped.each do |d| 
  pcc = PublicCostCenter.find_by(cost_center: hashmap2[d.esn])
  next if pcc.blank?
  next if pcc.rate_plan.nil?

  d.rate_plan = pcc.rate_plan
  esn_mapped_moved << d
end

iccid_mapped.each do |d| 
  pcc = PublicCostCenter.find_by(cost_center: hashmap3[d.iccid])
  next if pcc.blank?
  next if pcc.rate_plan.nil?

  d.rate_plan = pcc.rate_plan
  iccid_mapped_moved << d
end
