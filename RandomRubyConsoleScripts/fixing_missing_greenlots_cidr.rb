ca = CidrAllocation.new
ca.id = 189
ca.carrier_cidr_id = 1
ca.cidr = '100.86.80.0/22'
ca.pws_note = 'Repaired Greenlots Cidr'
ca.open_cidr = false

ca.save(validate: false)

CidrPool.create cidr_allocation_id: 189, account_id: 140

ca = CidrAllocation.new
ca.id = 190
ca.carrier_cidr_id = 2
ca.cidr = '10.23.176.0/21'
ca.pws_note = 'Repaired TCS Cidr'
ca.open_cidr = false
ca.save(validate: false)

CidrPool.create cidr_allocation_id: 190, account_id: 86

ca = CidrAllocation.new
ca.id = 191
ca.carrier_cidr_id = 1
ca.cidr = '100.86.22.0/24'
ca.pws_note = 'Repaired Petasense Cidr'
ca.open_cidr = false
ca.save(validate: false)

CidrPool.create cidr_allocation_id: 191, account_id: 69

