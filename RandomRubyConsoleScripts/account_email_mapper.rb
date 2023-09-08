Account.where(account_state: ['active', 'demo', 'nonpayment-hold'], primary_email: 'TBD').each do |act|
  act.intacct_configuration.update_m2m_billing_email if act.intacct_configuration.m2m_billing_emails.nil?
  act.primary_email = act.intacct_configuration.m2m_billing_emails&.split(/\s*,\s*/)&.first
  act.save
end
