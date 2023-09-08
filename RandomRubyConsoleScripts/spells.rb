def gather_data
  lotsa_data = {}
  url = "http://dndtools.org/spells/"
  (1..5).each do |i|
    uri = URI.parse(url + "?page=#{i}&page_size=1000")
    response = Net::HTTP.get_response(uri)
    noko = Nokogiri::HTML(response.body)

    noko.css('tr')[1..].each do |spell|
      td = spell.css('td')
      details_href = td[0].css('a').attr('href').to_s
      data = {
        name:   td[0].content,
        school: td[1].content,
        verbal:       td[2].css('img')[0].attr('alt'),
        somatic:      td[2].css('img')[1].attr('alt'),
        material:     td[2].css('img')[2].attr('alt'),
        arcane_focus: td[2].css('img')[3].attr('alt'),
        divine_focus: td[2].css('img')[4].attr('alt'),
        xp_cost:      td[2].css('img')[5].attr('alt'),
        rulebook: td[3].content,
        edition:  td[4].content
      }
      lotsa_data[details_href] = data
      rescue TypeError
    end
  end
  lotsa_data
end

def scrape_spell(key)
  url = "http://dndtools.org"
  resp = Net::HTTP.get_response(URI.parse(url + key))
  data = Nokogiri::HTML(resp.body)
end

lotsa_data = gather_data
tmp_yaml(lotsa_data)

lotsa_data.each_key do |key|
  next unless lotsa_data[key][:details].nil?
  lotsa_data[key][:details] = scrape_spell(key)
  lotsa_data[key][:details_text] = lotsa_data[key][:details].to_s
  sleep(0.2)
end

def extract_fun(contents)
  # get the description
  description = contents.css('.nice-textile').text.squeeze(" \n")
  # prune it out to make parsing the rest easier
  # contents.search('.nice-textile').remove
  text = contents.text.gsub(/\n\n/, ' #### ').gsub(/\n/, ' ')
  if text =~ /Level:\s*(.*?)##/
    level = $LAST_MATCH_INFO[1]
  end
  words = ['Casting Time:', 'Range:', 'Target:', 'Saving Throw:', 'Area:', 'Duration:', 'Spell Resistance:', 'Effect:', 'Special:', '###' ]

  if text =~ /Casting Time:\s*(.*?)(#{words.join('|')})/
    casting_time = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Range:\s*(.*?)(#{words.join('|')})/
    range = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Target:\s*(.*?)(#{words.join('|')})/
    target = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Saving Throw:\s*(.*?)(#{words.join('|')})/
    saving_throw = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Area:\s*(.*?)(#{words.join('|')})/
    area = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Duration:\s*(.*?)(#{words.join('|')})/
    duration = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Spell Resistance:\s*(.*?)(#{words.join('|')})/
    spell_res = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Effect:\s*(.*?)(#{words.join('|')})/
    effect = $LAST_MATCH_INFO[1].chomp(' ')
  end
  if text =~ /Special:\s*(.*?)(#{words.join('|')})/
    special = $LAST_MATCH_INFO[1].chomp(' ')
  end

  {
    description: description,
    level: level,
    casting_time: casting_time,
    range: range,
    area: area,
    target: target,
    duration: duration,
    saving_throw: saving_throw,
    spell_res: spell_res,
    effect: effect,
    special: special
  }
end

lotsa_data2 = lotsa_data.deep_dup
lotsa_data2.each_key { |k| lotsa_data2[k].delete :details }
tmp_yaml lotsa_data2

spells = YAML.load_file('/Users/andyspix/Desktop/spells.yaml')
spells.each_key { |k| spells[k][:details] = Nokogiri.parse(spells[k][:details_text]) }
spells.each_key { |k| spells[k][:content] = Nokogiri.parse(spells[k][:details_text]).css('#content') }
spells.each_key { |k| spells[k].delete :details; spells[k].delete :details_text }
spells.each_key { |k| spells[k][:content_text] = spells[k][:content].to_s) }
spells2 = spells.deep_dup

spells2.each_key { |k| spells2[k].delete :content }
tmp_yaml spells2

spells3 = YAML.load_file('/Users/andyspix/Desktop/spells2.yaml')
spells3.each_key { |k| spells3[k][:content] = Nokogiri.parse(spells3[k][:content_text]) }
spells3.each_key do |k|
  puts "spell: #{spells3[k][:name]}"
  spells3[k].merge! extract_fun spells3[k][:content]
end

spells3.each_key { |k| spells3[k].delete :content }
tmp_yaml spells3

def process_spell_column(value)
  return {} if value[:level].nil?
  ret = {}
  list = value[:level].split(',')
  classes = ["Sorcerer", "Wizard", "Warmage", "Sha'ir", "Dread Necromancer", "Beguiler", "Cleric", "Druid", "Wu Jen", "Warblade", "Trapsmith", "Swordsage", "Shugenja", "Sanctified", "Ranger", "Runescarred Berserker", "Paladin", "Hexblade", "Healer", "Duskblade", "Divine Bard", "Bard", "Crusader", "Champion of Gwynharwyf", "Blackguard", "Assassin", "Artificer", "Adept", "Vile Darkness"]
  list.each do |item|
    classes.each do |c|
      next unless item =~ /#{c}\s*(\d)\s*(\(.*\))?/
      ret[c.downcase.to_sym] = $LAST_MATCH_INFO[1]
    end
  end
  ret
end



rep = [%w(name school verbal somatic material arcane_focus divine_focus xp_cost sorcerer wizard cleric druid ranger paladin bard divine_bard assassin duskblade warmage wu_jen swordsage crusader warblade beguiler dread_necromancer sanctified vile_darkness sha_ir trapsmith shugenja runescarred_berserker hexblade healer champion_of_gwynharwyf blackguard artificer adept level casting_time range area target duration saving_throw spell_res effect special rulebook edition description)]
spells4.values.each do |s|
  rep << [s[:name], s[:school], s[:verbal], s[:somatic], s[:material], s[:arcane_focus], s[:divine_focus], s[:xp_cost], s[:sorcerer], s[:wizard], s[:cleric], s[:druid], s[:ranger], s[:paladin], s[:bard], s[:divine_bard], s[:assassin], s[:duskblade], s[:warmage], s[:wu_jen], s[:swordsage], s[:crusader], s[:warblade], s[:beguiler], s[:dread_necromancer], s[:sanctified], s[:vile_darkness], s[:sha_ir], s[:trapsmith], s[:shugenja], s[:runescarred_berserker], s[:hexblade], s[:healer], s[:champion_of_gwynharwyf], s[:blackguard], s[:artificer], s[:adept], s[:level], s[:casting_time], s[:range], s[:area], s[:target], s[:duration], s[:saving_throw], s[:spell_res], s[:effect], s[:special], s[:rulebook], s[:edition], s[:description].gsub(/\n/, '')]
end
tmp_csv(rep)

