data = read_csv '/tmp/daintree.csv'
account = Account.find_by(account_name: 'DAINTREE')

data.each do |x|
  name = x['DEVICE NAME'].delete("\t")
  ip = x['STATIC IP']
  note = x['CUSTOMER']
  note1 = x['MODEM NAME']
  note2 = x['MODEM TYPE : WAC Configuration']
  note3 = x['ACTIVATION DATE']

  device = Device.find_by(device_name: name)
  device ||= Device.find_by(ip_address: ip)
  next if device&.account != account

  device.update note: note, note1: note1, note2: note2, note3: note3
end
