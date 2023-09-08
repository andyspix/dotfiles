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

data = read_csv('db_tracking.csv')
chart_data = [%w(deletions insertions reads updates)]

data.each_with_index do |a, i|
  next if i.zero? # first datapoint has no reference
  chart_data << [
    a['deletions'].to_i - (data[i - 1]['deletions']).to_i,
    a['insertions'].to_i - (data[i - 1]['insertions']).to_i,
    a['reads'].to_i - (data[i - 1]['reads']).to_i,
    a['updates'].to_i - (data[i - 1]['updates']).to_i
  ]
end

File.open('db_display_data.csv', 'w') { |f| f.write(chart_data.inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }
