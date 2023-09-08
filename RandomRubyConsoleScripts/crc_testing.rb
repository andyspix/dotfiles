strings = []
file = File.open('/tmp/strings.txt', 'w')
ruby_file = File.open('/tmp/rubycrcs.txt', 'w')
load 'device_firmware_handler.rb'
dfh = DeviceFirmwareHandler.new(Account.find(1))
50000.times do
  strg = ''
  256.times { strg += %w(0 1 2 3 4 5 6 7 8 9 A B C D E F).sample }
  strings << strg
  file.puts strg
  ruby_file.puts dfh.get_crc(strg)
end

file.close
ruby_file.close
