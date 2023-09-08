# Verizon BI

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 25GB Dynamic - no SMS',
  api_code: 'FWA 10MBPS 25GB',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'GB',
  data_allowance: 25,
  rep_compensation: 69,
  access_charge: 69,
  overage_charge: 10,
  apn: 'vzwinternet',
)

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 50GB Dynamic - no SMS',
  api_code: 'FWA 25MBPS 50GB',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'GB',
  data_allowance: 50,
  rep_compensation: 99,
  access_charge: 99,
  overage_charge: 10,
  apn: 'vzwinternet',
)

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 150GB Dynamic - no SMS',
  api_code: 'FWA 50MBPS 150GB',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: false,
  data_unit: 'GB',
  data_allowance: 150,
  rep_compensation: 199,
  access_charge: 199,
  overage_charge: 10,
  apn: 'vzwinternet',
)

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 25GB Static - no SMS',
  api_code: 'FWA 10MBPS 25GB Static',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: true,
  data_unit: 'GB',
  data_allowance: 25,
  rep_compensation: 69,
  access_charge: 69,
  overage_charge: 10,
  apn: 'vzw_zipcode_based_apn',
)

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 50GB Static - no SMS',
  api_code: 'FWA 25MBPS 50GB Static',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: true,
  data_unit: 'GB',
  data_allowance: 50,
  rep_compensation: 99,
  access_charge: 99,
  overage_charge: 10,
  apn: 'vzw_zipcode_based_apn',
)

CarrierPlanBundle.create(
  name: 'Verizon Business Internet 150GB Static - no SMS',
  api_code: 'FWA 50MBPS 150GB Static',
  carrier_account_id: 14,
  allow_sms: false,
  network_is_private: false,
  ips_are_static: true,
  data_unit: 'GB',
  data_allowance: 150,
  rep_compensation: 199,
  access_charge: 199,
  overage_charge: 10,
  apn: 'vzw_zipcode_based_apn',
)

  CarrierPlanBundle.find(110).update name: 'VZWBI-10Mbps-Throttle@25GB-300GB-PUBD-noSMS'
  CarrierPlanBundle.find(111).update name: 'VZWBI-25Mbps-Throttle@50GB-300GB-PUBD-noSMS'
  CarrierPlanBundle.find(112).update name: 'VZWBI-50Mbps-Throttle@150GB-300GB-PUBD-noSMS'

  CarrierPlanBundle.find(113).update name: 'VZWBI-10Mbps-Throttle@25GB-300GB-PUBS-noSMS'
  CarrierPlanBundle.find(114).update name: 'VZWBI-25Mbps-Throttle@50GB-300GB-PUBS-noSMS'
  CarrierPlanBundle.find(115).update name: 'VZWBI-50Mbps-Throttle@150GB-300GB-PUBS-noSMS'

