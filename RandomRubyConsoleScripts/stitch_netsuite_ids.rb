nah = NetsuiteApiHandler.new
customers = nah.get_customer.parsed
h_map = customers.pluck(:intaactid, :id).to_h
h_map.delete ''

# Only the important ones:
InvoiceConfiguration.joins(:account).where('accounts.account_state': 'active').where(netsuite_id: nil).where.not(intacct_customerid: nil).each { |ic| ic.update netsuite_id: h_map[ic.intacct_customerid] }
# IntacctConfiguration.where(netsuite_id: nil).where.not(intacct_customerid: nil).each { |ic| ic.update netsuite_id: h_map[ic.intacct_customerid] }
