files = Dir.glob("/Users/andyspix/Downloads/detail_sheet_bulk_20230119170918/*")
a = File.open('/tmp/jnk.csv', 'w')
files.each do |f|
  name = File.basename(f).gsub('.csv', '')
  File.open(f, 'r') { |e| e.each {|line| a.puts "#{name},#{line}" } }
end


