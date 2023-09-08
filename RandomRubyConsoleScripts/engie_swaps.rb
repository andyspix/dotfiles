# Engie PN is 10.23.129.0/24
# PRIV Rate Plan is https://www.lattigo.com/rate_plans/274
# PUBS Rate Plan is https://www.lattigo.com/rate_plans/1371
# SKUS in the PRIV plan:
#     "VZW080000460053" => 300,
#     "VZW080000460069" => 160,
#     "VZW080000250038" => 129,
#     "VZW080000250049" => 111,
#     "VZW080000460098" => 61,
#                    "" => 45,
#     "VZW080000460086" => 15,
#     "VZW080000250037" => 2,
#     "VZW110000480086" => 1,
#     "VZW080000460048" => 1
#

# Script:
# Deactivate PUBS line
# Check VZW Logs
# Activate PN line
# Check VZW Logs
# Move Rate Plan
# Reload Device

# These are all of the public lines with Engie:
#swaps = %w( 89148000001653294362 89148000002339062306 89148000002636998541 89148000003441027385 89148000003917433596 89148000003917524618 89148000004738367831 89148000006071838708 89148000006071839268 89148000006105056392 89148000006408871414 89148000006408871901 89148000006840386112 )

# TODAY:
# imei: 358643075246988
attrs = d.attributes
swaps = %w(89148000006071838708)
devs = Device.where(device_name: swaps)

# Can't loop/each this, since customer wants one at a time.  We'll specify and run each manually....
d = devs.first

# grab the imei
imei = d.imei

# Deactivate
d.change_state 'deactivate'

# Check Logs manually in VZW Public Thingspace

# Remove old device from VZW
handler = VzwApiHandler.new

# Check Logs manually in VZW Public Thingspace

# Activate New Line in private plan
# Need to fix this, currently I don't automatically extract IP addresses from the CIDR allocations...
# 10.23.129.64	++
ip_address = 10.23.129.64
handler.activate(devs.first.device_name, RatePlan.find(274), imei, nil, ip_address)

# if we need to archive first, try: Device.archive_device_ids d.id, i_am_sure: true

# Check Logs manually in VZW Private Thingspace

# Update Rate Plan
d.update rate_plan: RatePlan.find(274)

# Lattigo should show new details at next cron - forcing a reload non-trivial due to stale carrier account, but could do:
d.update carrier_account_id: CarrierAccount.vzw_private_primary.id
d.update_information


# For Varitec
# Rate Plan for Varitec: 2762
d = Device.find_by(device_name: 89148000007473949051)
attrs = d.attributes
imei = d.imei
d.change_state 'deactivate'
handler = VzwApiHandler.new
handler.activate(attrs['device_name'], RatePlan.find(2762), imei, nil, '10.23.201.129')
d.update rate_plan: RatePlan.find(2762)

