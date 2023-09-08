swaps = [
  {old: "89148000004917805650", imei: "351710090918086", new: "89148000008229759380"},
  {old: "89148000007184565345", imei: "351710090845222", new: "89148000008229759315"},
  {old: "89148000008307902803", imei: "351710091391077", new: "89148000008229778737"},
  {old: "89148000004917805510", imei: "351710090948257", new: "89148000008229759372"},
  {old: "89148000004917289319", imei: "351710090869172", new: "89148000008229759356"},
  {old: "89148000004917289376", imei: "351710090912139", new: "89148000008229759349"},
  {old: "89148000004917288766", imei: "351710090862466", new: "89148000008229759281"},
  {old: "89148000004917289467", imei: "351710090910224", new: "89148000008229759265"},
  {old: "89148000004917288733", imei: "351710090910273", new: "89148000008229759257"},
  {old: "89148000004917942818", imei: "351710090678599", new: "89148000008229759398"},
  {old: "89148000004917805130", imei: "351710090486118", new: "89148000008229759406"},
  {old: "89148000004917408802", imei: "351710090464024", new: "89148000008229759232"},
  {old: "89148000004434349232", imei: "351710090421479", new: "89148000008229759323"},
  {old: "89148000004917921184", imei: "351710090613950", new: "89148000008229759240"},
  {old: "89148000004917948625", imei: "351710090682062", new: "89148000008229759364"},
  {old: "89148000004917942875", imei: "351710090673335", new: "89148000008229759414"},
  {old: "89148000004917948229", imei: "351710090711754", new: "89148000008229759307"},
  {old: "89148000004917289558", imei: "351710090912113", new: "89148000008229759299"},
  {old: "89148000004917289590", imei: "351710090910257", new: "89148000008229759273"},
  {old: "89148000004440728262", imei: "351710090231886", new: "89148000008229759331"}
]


# Simple sanity check before proceeding...
if swaps.count == Device.where(device_name: swaps.pluck(:old)).count && Device.where(device_name: swaps.pluck(:new)).empty?
  handler = VzwApiHandler.new
  swaps.each do |s|
    # Make a stub that looks like the old device:
    d = Device.find_by(device_name: s[:old])
    s[:stub] = Device.create(device_name: s[:new], note: d.note, note1: d.note1, note2: d.note2, note3: d.note3,
                             rate_plan: d.rate_plan, carrier_account_id: d.carrier_account_id, state: 'Swap Requested')
    s[:stub].update contract_end_date: d.contract_end_date

    # Submit the swaps
    s[:swap_resp] = handler.change_device_id(d, s[:new], s[:imei])
  end
end

# Wait until all callbacks have returned:
swaps.all? { |s| s[:swap_resp].callback_response.reload.payload.present? }

# Note Status - If all Success we're done:
ap swaps.map { |s| j = JSON.parse(s[:swap_resp].callback_response.payload); [j['status'], j['deviceIds'].first['id']].join(': ') }

# Find Failing swaps, which now have stubs, for them we usually do a SKU based activation + Deactivation of the old line.
# 90% of the time our customers don't care.
# Rare exceptions can occur when maintaining MDN or IP-Address is critical.  Also need to verify if
#     "faultstring": "REQUEST_FAILED. ChangeDeviceIdentifierTo device already exists."
# is present, because these cannot be fixed by deactivation/activation


swap_errors = swaps.select { |s| JSON.parse(s[:swap_resp].callback_response.payload)['status'] == 'Failed' }
swap_errors.each do |s|
  handler = VzwApiHandler.new
  sku = 'VZW080000250042' # Set a manual SKU overrid, else get a generic Cradlepoint
  s[:activate_resp] = handler.activate(s[:stub].device_name, s[:stub].rate_plan, nil, sku || 'VZW080000100037')
end

# Wait until all activation callbacks have returned:
swap_errors.all? { |s| s[:activate_resp].callback_response.reload.payload.present? }
ap swap_errors.map { |s| j = JSON.parse(s[:activate_resp].callback_response.payload); [j['status'], j['deviceIds'].first['id']].join(': ') }

# If the activation works, deactivate the old lines, else debug manually
activate_successes = swap_errors.select { |s| JSON.parse(s[:activate_resp].callback_response.payload)['status'] == 'Success' }
activate_successes.each do |s|
  Device.find_by(device_name: s[:old]).change_state 'deactivate'
end

# Debug these as real errors, likely need VZW Support:
ap swap_errors - activate_successes
