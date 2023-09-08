#cleanup bogus
IntacctInvoiceHistory.where(date_posted: 'Sun, 22 Jul 0003').update date_posted: Date.parse('2022-02-08')
IntacctInvoiceHistory.where(date_posted: 'Wed, 22 Sep 0006').destroy_all
IntacctInvoiceHistory.where(date_posted: 'Sat, 21 Jan 0008').destroy_all
IntacctInvoiceHistory.where(date_posted: 'Sun, 21 Jul 0009').destroy_all
IntacctInvoiceHistory.where(date_posted: 'Wed, 05 May 2021').destroy_all

# Fix Missing May
IntacctInvoiceHistory.where(date_posted: 'Thu, 05 May 2022')

csv = read_csv ('/Users/andyspix/Desktop/intacct_csvs/intacct_summary_April_2022.csv')
hash = csv.group_by{|x| x['PwsAccountNumberName']}
vals = hash.map { |k,v| [k, v.pluck('Amount').map(&:to_f).sum.round(2)] }.to_h
vals.each do |k,v|
  next unless IntacctInvoiceHistory.where(date_posted: 'Thu, 05 May 2022', account_number_name: k).empty?
  IntacctInvoiceHistory.create(date_posted: 'Thu, 05 May 2022', account_number_name: k, total_due: v)
end

