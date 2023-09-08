'https://www.psionics.info/powers/astral-construct--xph/'

def scrape_power(node, url)
  resp = Net::HTTP.get_response(URI.parse(url + node[:href]))
  data = Nokogiri::HTML(resp.body)
  fields = data.css('#manifesting').children.map { |a| a.text }.reject { |a| a.match /^\n\t+\s*$/ }
  result = {}
  fields.each_with_index do |f, i|
    result[:level] = fields[i+1] if f.downcase.match?('level') && i <= 2
    result[:likely_level] = likely_level(fields[i+1]) if f.downcase.match?('level') && i<= 2
    result[:display] = fields[i+1] if f.downcase.match? 'display'
    result[:mft_time] = fields[i+1] if f.downcase.match? /mft.*time/
    result[:target] = fields[i+1] if f.downcase.match? 'target'
    result[:range] = fields[i+1] if f.downcase.match? 'range'
    result[:duration] = fields[i+1] if f.downcase.match? 'duration'
    result[:cost] = fields[i+1] if f.downcase.match? 'cost'
  end
  result[:description] = data.css('#description').text,
  result[:rating] = data.css('.rateit').first.nil? ? 'None' : data.css('.rateit').first['data-rateit-value']
  result
end

def likely_level(str)
  most = 1
  most = 2 if str.count('2') >= most
  most = 3 if str.count('3') >= most
  most = 4 if str.count('4') >= most
  most = 5 if str.count('5') >= most
  most = 6 if str.count('6') >= most
  most = 7 if str.count('7') >= most
  most = 8 if str.count('8') >= most
  most = 9 if str.count('9') >= most
  most
end

url = "https://www.psionics.info"
uri = URI.parse(url + '/powers/')
response = Net::HTTP.get_response(uri)
noko = Nokogiri::HTML(response.body)

lotsa_data = {}
noko.css('.power').each do |power|
  name = power.content
  next if lotsa_data.key? name
  puts "Scraping: #{name}"
  data = scrape_power(power, url)
  data[:name] = name
  lotsa_data[name] = data
  sleep rand(0.2)
  rescue TypeError
end

lotsa_data.each do |k,v|
  v[:book] = []
  v[:book] << 'CPSi' if (k.match?(/CPsi$/) || v[:name].match?(/CPsi$/))
  v[:book] << 'SoS' if (k.match?(/SoS$/) || v[:name].match?(/SoS$/))
  v[:book] << 'Hyper' if (k.match?(/Hyper$/) || v[:name].match?(/Hyper$/))
  v[:book] << 'MoE' if (k.match?(/MoE$/) || v[:name].match?(/MoE$/))
  v[:book] << 'FoE' if (k.match?(/FoE$/) || v[:name].match?(/FoE$/))
  v[:book] << 'RotW' if (k.match?(/RotW$/) || v[:name].match?(/RotW$/))
  v[:book] << 'WoL' if (k.match?(/WoL$/) || v[:name].match?(/WoL$/))
  v[:book] << 'RoD' if (k.match?(/RoD$/) || v[:name].match?(/RoD$/))
  v[:book] << 'DrM' if (k.match?(/DrM$/) || v[:name].match?(/DrM$/))
  v[:book] << 'Frost' if (k.match?(/Frost$/) || v[:name].match?(/Frost$/))
  v[:book] << 'ME' if (k.match?(/ME$/) || v[:name].match?(/ME$/))
  v[:book] << 'MoI' if (k.match?(/MoI$/) || v[:name].match?(/MoI$/))
  v[:book] << 'Storm' if (k.match?(/Storm$/) || v[:name].match?(/Storm$/))
  v[:book] = v[:book].join(',')
end

rep = [%w(Name LikelyLevel Cost Rating Duration Range Target ManifestTime Display Book Level Description)]
lotsa_data.values.each { |a| rep << [a[:name], a[:likely_level], a[:cost], a[:rating], a[:duration], a[:range], a[:target], a[:mft_time], a[:display], a[:book], a[:level], a[:description] ] }

tmp_csv(rep)
