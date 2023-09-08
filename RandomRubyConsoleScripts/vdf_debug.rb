# csv = read_csv('/Users/andyspix/Desktop/CENRTD_US_1493_99999914013_1000032186_RI_20220902_000.csv')
h1 = Hash.new(0)
csv = read_csv('/tmp/vdf_aug.csv')
csv.pluck('IMSI', 'VOLUME').each { |x,y| h1[x] += y.to_i }
date1 = Date.parse('August 1, 2022')
res1 = h1.sort_by { |k,v| -v }.map { |k, v| mdus = Device.find_by(device_name: k).monthly_data_usages; ["#{k}\t", v, mdus.find_by(date_for: date1)&.bytes_used] }
tmp_csv res1

h2 = Hash.new(0)
csv2 = read_csv('/tmp/vdf_sept.csv')
csv2.pluck('IMSI', 'VOLUME').each { |x,y| h2[x] += y.to_i }
date2 = Date.parse('September 1, 2022')
res2 = h2.sort_by { |k,v| -v }.map { |k, v| mdus = Device.find_by(device_name: k).monthly_data_usages; ["#{k}\t", v, mdus.find_by(date_for: date2)&.bytes_used] }
tmp_csv res2



