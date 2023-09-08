def read_csv(infile)
  require 'csv'
  quote_chars = %w(" | ~ ^ & *)
  begin
    csv_text = File.open(infile, 'r:bom|utf-8')
    CSV.parse(csv_text, headers: true, quote_char: quote_chars.shift, liberal_parsing: true)
  rescue CSV::MalformedCSVError
    quote_chars.empty? ? raise : retry
  end
end

big_hash = {}
# Dir.glob('/Users/andyspix/Desktop/intacct_csvs/*summary*').each do |file|
Dir.glob('/Users/andyspix/Desktop/*_data.csv').each do |file|
  next if File.directory?(file)
  csv = read_csv(file)
  date = Date.parse(file.gsub('/Users/andyspix/Desktop/intacct_csvs/intacct_summary_/',''))
  csv.each do |line|
    big_hash[date] ||= {}
    big_hash[date][line['PwsAccountNumberName']] ||= {}
    big_hash[date][line['PwsAccountNumberName']]['total'] ||= 0
    big_hash[date][line['PwsAccountNumberName']]['mrc'] ||= 0
    big_hash[date][line['PwsAccountNumberName']]['ovg'] ||= 0
    big_hash[date][line['PwsAccountNumberName']]['misc'] ||= 0
    big_hash[date][line['PwsAccountNumberName']]['total'] += line['Amount'].to_f
    if line['Element'].match?(/MRC/)
      big_hash[date][line['PwsAccountNumberName']]['mrc'] += line['Amount'].to_f
    elsif line['Element'].match?(/OVG/)
      big_hash[date][line['PwsAccountNumberName']]['ovg'] += line['Amount'].to_f
    else
      big_hash[date][line['PwsAccountNumberName']]['misc'] += line['Amount'].to_f
    end
  end
end

big_hash.each do |k, v|
  v.each do |k1, v1|
    IntacctInvoice.create billing_period: k, account_number_name: k1, total_charges: v1['total'], ovg_charges: v1['ovg'], mrc_charges: v1['mrc'], misc_charges: v1['misc']
  end
end

all_keys = big_hash.values.map(&:keys).flatten.uniq

all_keys.map do |k|
  jan = big_hash[big_hash.keys.first]
  feb = big_hash[big_hash.keys.second]
  [ k,
    jan[k].nil? ? 0 : jan[k]['total'].to_f,
    feb[k].nil? ? 0 : feb[k]['total'].to_f,
    (jan[k].nil? ? 0 : jan[k]['total'].to_f) -
    (feb[k].nil? ? 0 : feb[k]['total'].to_f)
  ]
end
