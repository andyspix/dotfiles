
[%w(NetsuiteId IntacctCustomerId AccountName AccountState PrimaryContactName PrimaryContactPhone PrimaryEmail TechincalName TechnicalPhone TechnicalEmail)] +
  InvoiceConfiguration.all.map do |ic|
  act = ic.account
  tec = ic.account.api_technical_contacts.first
  [ic.netsuite_id, ic.intacct_customerid, act.account_name, act.account_state, act.primary_contact, act.primary_phone, act.primary_email, tec&.name, tec&.phone, tec&.email_address ]
end




