feb = CarrierAccount.find(5).devices.joins(:monthly_data_usages).where('monthly_data_usages.date_for': Date.parse('Feb 1 2023')).order('monthly_data_usages.bytes_used': :desc); 0
mar = CarrierAccount.find(5).devices.joins(:monthly_data_usages).where('monthly_data_usages.date_for': Date.parse('Mar 1 2023')).order('monthly_data_usages.bytes_used': :desc); 0

feb_h = feb.pluck(:device_name, :'monthly_data_usages.bytes_used').to_h; 0
mar_h = mar.pluck(:device_name, :'monthly_data_usages.bytes_used').to_h; 0
