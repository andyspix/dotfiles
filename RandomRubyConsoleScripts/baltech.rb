csv = read_csv '/tmp/dev.csv'
hash = {}
csv.each { |row| hash[row['Id']] = row['Days'].to_i - 5 }
hash.each { |k,v| Device.find(k).update contract_end_date: Date.today + v.days }
