vzw = VzwApiHandler.new
dia_plans = VzwApiHandler::VzwApiResponse.new vzw.vzw_request(CarrierAccount.vzw_dia, :get, "https://thingspace.verizon.com/api/m2m/v1/plans/#{CarrierAccount.vzw_dia.carrier_account_number}", nil), 'custom'
pub_plans = VzwApiHandler::VzwApiResponse.new vzw.vzw_request(CarrierAccount.vzw_public, :get, "https://thingspace.verizon.com/api/m2m/v1/plans/#{CarrierAccount.vzw_public.carrier_account_number}", nil), 'custom'
prv_plans = VzwApiHandler::VzwApiResponse.new vzw.vzw_request(CarrierAccount.vzw_private_primary, :get, "https://thingspace.verizon.com/api/m2m/v1/plans/#{CarrierAccount.vzw_private_primary.carrier_account_number}", nil), 'custom'

pub_counts = CarrierAccount.vzw_public.devices.where(state: ['active', 'suspend']).pluck(:carrier_rate_plan).tally
prv_counts = CarrierAccount.vzw_private_primary.devices.where(state: ['active', 'suspend']).pluck(:carrier_rate_plan).tally
dia_counts = CarrierAccount.vzw_dia.devices.where(state: ['active', 'suspend']).pluck(:carrier_rate_plan).tally

a = dia_plans.parsed.map { |x| ['DIA', x['name'], x['code'], x['carrierServicePlanCode'], x['sizeKb'], dia_counts[x['code']]] }
b = prv_plans.parsed.map { |x| ['PRIVATE', x['name'], x['code'], x['carrierServicePlanCode'], x['sizeKb'], prv_counts[x['code']]] }
c = pub_plans.parsed.map { |x| ['PUBLIC', x['name'], x['code'], x['carrierServicePlanCode'], x['sizeKb'], pub_counts[x['code']]] }

tmp_csv [%w(Account Name Code CarrierServicePlanCode SizeKb CurrentDeviceCount), *a, *b, *c]


CarrierAccount.vzw_public.devices.where(state: ['active', 'suspend']).pluck(:carrier_rate_plan).tally.to

