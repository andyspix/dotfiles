data = read_csv '/tmp/digital_fleet_upload.csv'
account = Account.find_by(account_name: 'Digital Fleet, LLC')

data.each do |x|
  name = x['Device name']
  note = x['Note']
  note1 = x['Note1']

  device = Device.find_by(device_name: name)
  next if device&.account != account

  device.update note: note, note1: note1
end
