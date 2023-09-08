client = Aws::CloudWatch::Client.new

def csrs
  {
    'CSR1-VZW-AWSL'         => { name: 'InstanceId', value: 'i-084f9d58eedcc1b91' },
    'CSR2-VZW-AWSL'         => { name: 'InstanceId', value: 'i-00ca24acef2d313cb' },
    'CSR3-VF-AWSL'          => { name: 'InstanceId', value: 'i-0e5d7b8b0c3426adc' },
    'CSR4-VF-AWSL'          => { name: 'InstanceId', value: 'i-0db0dcf803d1e997e' },
    'CSR5-ATT-AWSL'         => { name: 'InstanceId', value: 'i-0e397e1816d0897ce' },
    'CSR6-ATT-BYOL'         => { name: 'InstanceId', value: 'i-086137bad340348fc' },
    'CSR9-VZW-DIA'          => { name: 'InstanceId', value: 'i-00fa1376215c40e9f' },
    'CSR10-VZW-DIA'         => { name: 'InstanceId', value: 'i-0a0d872d04d5ece5f' },
    'CSR11-SWIR-AWSL'       => { name: 'InstanceId', value: 'i-09b37b9ad1bbbc7ce' },
    'CSR12-SWIR-AWSL'       => { name: 'InstanceId', value: 'i-0c55780bf09fa247c' },
    'CSR13-KORE-AWSL'       => { name: 'InstanceId', value: 'i-0a34f6edf9ae74181' },
    'CSR14-KORE-BYOL'       => { name: 'InstanceId', value: 'i-0f8d506ffae39b9cb' },
    'CSR15-TELUS-AWSL'      => { name: 'InstanceId', value: 'i-07598225ddb72e527' },
    'CSR16-TELUS-AWSL'      => { name: 'InstanceId', value: 'i-009151e559076ad03' },
    'CSR19-TEAL-AWSL'       => { name: 'InstanceId', value: 'i-0472b2c0b7334327c' },
    'CSR20-TEAL-AWSL'       => { name: 'InstanceId', value: 'i-0f34f498c1f5a2c2d' },
    'CSR23-TMO-DIRECT-AWSL' => { name: 'InstanceId', value: 'i-03b4f30bbc2585d93' },
    'CSR24-TMO-DIRECT-AWSL' => { name: 'InstanceId', value: 'i-0da1fb2a41601b89f' }
  }
end

def get_traffic(box, metric: 'NetworkPacketsOut', client: Aws::CloudWatch::Client.new, start_time: Time.now - 5.minutes, end_time: Time.now, period: 60, statistics: ['Average', 'Maximum', 'Minimum'], unit: 'Count')
  client.get_metric_statistics namespace: 'AWS/EC2',
    period: period,
    start_time: start_time,
    end_time: end_time,
    metric_name: 'NetworkPacketsOut',
    statistics: statistics,
    unit: unit,
    dimensions: [box]
end

res = get_outputs(start_time: Time.now - 20.minutes, period: 60).datapoints.sort_by { |x| x.timestamp }

