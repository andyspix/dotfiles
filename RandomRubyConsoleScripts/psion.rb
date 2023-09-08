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
    result[:area] = fields[i+1] if f.downcase.match? 'area'
    result[:save] = fields[i+1] if f.downcase.match? /^save$/
    result[:pr] = fields[i+1] if f.downcase.match? /^pr$/
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

tmp_yaml lotsa_data

# Cleanup
lotsa_data = YAML.load_file('/tmp/tmp_yaml.yaml')
lotsa_data.each do |k,v|
  v[:book] = []
  %w(CPsi SoS Hyper MoE FoE RotW WoL RoD DrM Frost ME MoI Storm).each do |book|
    v[:book] << book if k.match?(/#{book}$/) || v[:name].match?(/#{book}$/)
    v[:name].gsub!(book, ' - ' + book)
  end
  v[:book] = v[:book].join(',')
  v[:description] = v[:description].first.gsub(/[\t\r\n]+/, '-').chomp('-')
  v[:base] = true if v[:level].match?('Psion/Wilder')
  v[:discipline] = true if v[:level].match?(/Seer|Egoist|Telepath|Nomad|Shaper|Kineticist/)
  v[:mantle] = true if v[:level].match?(/Elements|Physical Power|Pain and Suffering|Magic|Natural World|Time|Consumption|The Planes|Creation|Communication|Justice|Deception|Life|Corruption and Madness|Knowledge|Chaos|Good|Fate|Lightness and Darkness|Force|Mental Power|Death|Guardian|Evil|Freedom|Conflict|Destruction|Repose|Energy|Law/)
  v[:psywar] = true if v[:level].match?(/Psychic Warrior/)
  v[:psyrogue] = true if v[:level].match?(/Psychic Rogue/)
  v[:lurk] = true if v[:level].match?(/Lurk/)
  v[:medic] = true if v[:level].match?(/Worldthought Medic/)
end


rep = [%w(Name LikelyLevel Cost Rating Duration Range Save PR Area Target ManifestTime Display Book Base? Discipline? Mantle? PsyWar? PsyRogue? Lurk? Medic? Level Description)]
lotsa_data.values.each { |a| rep << [a[:name], a[:likely_level], a[:cost], a[:rating], a[:duration], a[:range], a[:save], a[:pr], a[:area], a[:target], a[:mft_time], a[:display], a[:book], a[:base], a[:discipline], a[:mantle], a[:psywar], a[:psyrogue], a[:lurk], a[:medic], a[:level], a[:description] ] }

tmp_csv(rep)

tmp_yaml lotsa_data
