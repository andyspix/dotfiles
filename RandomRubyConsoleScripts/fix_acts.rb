acts = ActivationChargeHistory.where(created_at: Date.today.beginning_of_month..Date.today).pluck(:device_id, :account_id);0
trms = TrmChargeHistory.where(created_at: Date.today.beginning_of_month..Date.today).pluck(:device_id, :account_id);0
bhs = BillingHistory.where(billing_period: BillingHistory.last.billing_period);0

res = acts.map { |act| bhs.where(account_id: act[1], device_id: act[0]).count }

