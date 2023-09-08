invoices = []
nah = NetsuiteApiHandler.new
Account.needs_billing.joins(:invoice_configuration).pluck(:netsuite_id).compact.each do |ic|
  invoices << [ic, nah.get_invoice(ic, trandate_after: Date.today.days_ago(10), due_before: Date.today)]
end

invs = invoices.map {|x| x[1].parsed}

invs.flatten.reject { |x| x[:memo] != 'Connectivity and Services' }
c_a_s = invs.flatten.reject { |x| x[:memo] != 'Connectivity and Services' }
