# CidrPool           -- Joins multiple cidr allocations to one account (maybe should be rate_plans?)
:account_id
:cidr_allocation_id

# CidrAllocation
:carrier_cidr_id
:cidr
:open_cidr
:pws_note
:locked

# CarrierCidr
:carrier_pool_name
:carrier_account_id
:cidr
:pws_note
:locked

# IpAssignment
:carrier_cidr_id
:cidr_allocation_id
:device_id
:ip_address
:status

# Core of Mike's processing is pretty much cidr_allocation.claim_next_address.  Figure out WTF is going on here.

# ACCOUNTS
# has_many :cidr_pools, dependent: :destroy, inverse_of: :account
# has_many :cidr_allocations, through: :cidr_pools
# has_many :ip_assignments, through: :cidr_allocations
#
# DEVICES
# has_one :ip_assignment
#
# RATE_PLANS
# has_many :cidr_allocations, through: :account
# has_many :ip_assignments, through: :cidr_allocations
