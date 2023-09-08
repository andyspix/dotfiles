

cpb1 = CarrierPlanBundle.find(68)
cpb2 = CarrierPlanBundle.find(75)
cpb3 = CarrierPlanBundle.new(cpb1.attributes)
cpb4 = CarrierPlanBundle.new(cpb2.attributes)
cpb3.id = nil
cpb4.id = nil
cpb3.unlock_bundle
cpb4.unlock_bundle
cpb3.ips_are_static = true
cpb4.ips_are_static = true
cpb3.save
cpb4.save
cpb3.update name: cpb3.name + ' - StaticIp'
cpb4.update name: cpb4.name + ' - StaticIp'


# TMO DIRECT

cpb1 = CarrierPlanBundle.create(
  name: 'Tmobile-Direct with SMS - Manual',
  api_code: 'Tmobile-Direct Manual',
  carrier_account_id: 11,
  allow_sms: true,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'GB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb2 = CarrierPlanBundle.create(
  name: 'Tmobile-Direct no SMS - Manual',
  api_code: 'Tmobile-Direct Manual',
  carrier_account_id: 11,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'GB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb3 = CarrierPlanBundle.new(cpb1.attributes)
cpb4 = CarrierPlanBundle.new(cpb2.attributes)
cpb3.id = nil
cpb4.id = nil
cpb3.unlock_bundle
cpb4.unlock_bundle
cpb3.ips_are_static = true
cpb4.ips_are_static = true
cpb3.save
cpb4.save
cpb3.update name: cpb3.name + ' - StaticIp'
cpb4.update name: cpb4.name + ' - StaticIp'

# TEAL

cpb1 = CarrierPlanBundle.create(
  name: 'PWS (Teal) with SMS - Manual',
  api_code: 'PWS (Teal) Manual',
  carrier_account_id: 12,
  allow_sms: true,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'MB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb2 = CarrierPlanBundle.create(
  name: 'PWS (Teal) no SMS - Manual',
  api_code: 'PWS (Teal) Manual',
  carrier_account_id: 12,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'MB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb3 = CarrierPlanBundle.new(cpb1.attributes)
cpb4 = CarrierPlanBundle.new(cpb2.attributes)
cpb3.id = nil
cpb4.id = nil
cpb3.unlock_bundle
cpb4.unlock_bundle
cpb3.ips_are_static = true
cpb4.ips_are_static = true
cpb3.save
cpb4.save
cpb3.update name: cpb3.name + ' - StaticIp'
cpb4.update name: cpb4.name + ' - StaticIp'


# TEAL/TMD private bundles
CarrierAccount.find(11).carrier_plan_bundles.each do |cpb|
  c = CarrierPlanBundle.new cpb.attributes
  c.id = nil
  c.unlock_bundle
  c.network_is_private = true
  c.name = c.name + ' - Private'
  c.save
end

CarrierAccount.find(12).carrier_plan_bundles.each do |cpb|
  c = CarrierPlanBundle.new cpb.attributes
  c.id = nil
  c.unlock_bundle
  c.network_is_private = true
  c.name = c.name + ' - Private'
  c.save
end

# WLO

cpb1 = CarrierPlanBundle.create(
  name: 'Wireless Logic with SMS - Manual',
  api_code: 'Wireless Logic Manual',
  carrier_account_id: 13,
  allow_sms: true,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'MB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb2 = CarrierPlanBundle.create(
  name: 'Wireless Logic no SMS - Manual',
  api_code: 'Wireless Logic Manual',
  carrier_account_id: 13,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'MB',
  data_allowance: 0,
  rep_compensation: 0,
  access_charge: 0,
  overage_charge: 0,
  apn: 'tbd',
)

cpb3 = CarrierPlanBundle.new(cpb1.attributes)
cpb4 = CarrierPlanBundle.new(cpb2.attributes)
cpb3.id = nil
cpb4.id = nil
cpb3.unlock_bundle
cpb4.unlock_bundle
cpb3.ips_are_static = true
cpb4.ips_are_static = true
cpb3.save
cpb4.save
cpb3.update name: cpb3.name + ' - StaticIp'
cpb4.update name: cpb4.name + ' - StaticIp'


# WLO private bundles
CarrierAccount.find(13).carrier_plan_bundles.each do |cpb|
  c = CarrierPlanBundle.new cpb.attributes
  c.id = nil
  c.unlock_bundle
  c.network_is_private = true
  c.name = c.name + ' - Private'
  c.save
end

