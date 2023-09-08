# All Devices from all time, grouped by state/account including cancelled lines:
Device.joins(:carrier_account).group('carrier_accounts.carrier_account_name', :state).count

ap Device.joins(:carrier).where.not(state: 'Line Swapped').group('carriers.carrier_name', :state).count

