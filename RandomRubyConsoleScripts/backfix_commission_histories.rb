CommissionHistory.select do |ch|
  if ch.commission_configuration.nil? || ch.commission_configuration.pws_cost.nil?
    false
  else
    alt_amount = ch.commission_configuration.payout
    ch.amount != alt_amount
  end
end



