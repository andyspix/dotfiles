@account = Account.find(3)
invoice = @account.invoice_configuration.fetch_invoice_data_by_internalid(6443663)
cust = NetsuiteApiHandler.new.get_customer @account.invoice_configuration.netsuite_id
cust_data = cust.parsed.first

terms = NetsuiteApiHandler.new.get_term
default = Hash.new('Due Upon Receipt')
terms_map = terms.valid? ? default.merge(terms.parsed.pluck(:id, :name).to_h) : default

load "#{Rails.root}/lib/netsuite_pdf_writer.rb"
file = File.open("/Users/andyspix/Desktop/#{invoice[:tranid]}.pdf", 'w')
NetsuitePdfWriter.new.write_pdf file, invoice, cust_data, terms_map

