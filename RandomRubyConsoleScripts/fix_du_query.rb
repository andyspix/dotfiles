

Benchmark.measure do
        @today = Date.today
      ddu_data1 = Device.joins(:daily_data_usages).where('daily_data_usages.date_for': @today).group(:'daily_data_usages.date_for', :carrier_account_id).sum(:'daily_data_usages.bytes_used')
      ddu_data2 = Device.joins(:daily_data_usages).where('daily_data_usages.date_for': @today - 1.day).group(:'daily_data_usages.date_for', :carrier_account_id).sum(:'daily_data_usages.bytes_used')
      ddu_data3 = Device.joins(:daily_data_usages).where('daily_data_usages.date_for': @today - 7.days).group(:'daily_data_usages.date_for', :carrier_account_id).sum(:'daily_data_usages.bytes_used')
      mdu_data1 = Device.joins(:monthly_data_usages).where('monthly_data_usages.date_for': @today.beginning_of_month).group(:'monthly_data_usages.date_for', :carrier_account_id).sum(:'monthly_data_usages.bytes_used')
      mdu_data2 = Device.joins(:monthly_data_usages).where('monthly_data_usages.date_for': @today.beginning_of_month - 1.month).group(:'monthly_data_usages.date_for', :carrier_account_id).sum(:'monthly_data_usages.bytes_used')
      @carrier_table = []
      CarrierAccount.order(carrier_account_name: :asc).pluck(:carrier_account_name, :carrier_account_number, :id).each do |carrier_account_name, carrier_account_number, id|
        devs      = CarrierAccount.find(id).devices
        active    = devs.where(state: 'active').count
        today     = ddu_data1[[@today, id]]
        yesterday = ddu_data2[[@today - 1.day, id]]
        last_week = ddu_data3[[@today - 7.days, id]]
        this_month = mdu_data1[[@today.beginning_of_month, id]]
        last_month = mdu_data2[[@today.beginning_of_month - 1.month, id]]
        @carrier_table << [carrier_account_name, carrier_account_number, active, devs.count, today, yesterday, last_week, this_month, last_month]
      end
end
