def tuple_hash(ary)
  ary.map { |x| [x[0], x[1..-1]] }.to_h
end

# about 50s for 10k updates
Device.limit(100000).update_all(bytes_used: -1, sms_used: -1); 0
Benchmark.measure do
  devs = tuple_hash(Device.pluck(:id, :bytes_used, :sms_used).map { |x,y,z| [x, y.to_i, z.to_i] }); 0
  mdus = tuple_hash Device.joins(:monthly_data_usages).where('monthly_data_usages.date_for': Date.today.beginning_of_month).pluck(:device_id, :'monthly_data_usages.bytes_used', :'monthly_data_usages.sms_used'); 0
  zeds = tuple_hash devs.keys.map { |x| [x, 0, 0] }; 0
  mdus.reverse_merge!(zeds); 0
  diffs = (mdus.to_a - devs.to_a);0
  diffs.each { |d| Device.find(d[0]).update bytes_used: d[1], sms_used: d[2] };0
end

# Upsert is under 10s for 100k devices in slices of 5k
# Upsert is under 15s for 100k devices in slices of 100
# Upsert is under 45s for 100k devices in slices of 10
Device.limit(100000).update_all(bytes_used: -1, sms_used: -1); 0
Benchmark.measure do
  devs = tuple_hash(Device.pluck(:id, :bytes_used, :sms_used).map { |x,y,z| [x, y.to_i, z.to_i] }); 0
  mdus = tuple_hash Device.joins(:monthly_data_usages).where('monthly_data_usages.date_for': Date.today.beginning_of_month).pluck(:device_id, :'monthly_data_usages.bytes_used', :'monthly_data_usages.sms_used'); 0
  zeds = tuple_hash devs.keys.map { |x| [x, 0, 0] }; 0
  mdus.reverse_merge!(zeds); 0
  diffs = (mdus.to_a - devs.to_a).map { |k, v| {id: k, device_name: 'n/a', bytes_used: v[0], sms_used: v[1] } };0
  diffs.each_slice(100).each do |slice|
    Device.upsert_all slice, update_only: [:bytes_used, :sms_used]
  end
end
