def item_list
  mrcs = ["0 Bytes"] + (['KB', 'MB', 'GB'].map { |u| [ 1, 2, 3, 4, 5, 8, 10, 15, 20, 25, 30, 35, 40, 50, 60, 75, 80, 100, 150, 200, 250, 300, 400, 500, 750].map { |n| "#{n} #{u}" }.flatten }.flatten)
  ovgs = ['1 KB', '1 MB', '1 GB']
  commits = [10000, 15000, 25000, 50000, 100000, 150000, 250000]
  code_class = [
    ['ATT', 'ATT_100374402_PN--ATT Private'],
    ['VZW', 'VZW_645_778_PN--Verizon Private'],
    ['VZW', 'VZW_742071985_DIA--Verizon DIA'],
    ['VZW', 'VZW_742006538_PUB--Verizon Public'],
    ['VDF', 'VDF_1000032186_PN--Vodafone Private'],
    ['TMO', 'TMO_BAN0001_PN--T-Mobile Private'],
    ['TMD', 'TMD_500417240__TMobile Direct--T-Mobile Direct'],
    ['SRA', 'SWN_431915313_PN--SW Private'],
    ['TLS', 'TLS_100213113--Telus Private'],
    ['PWS', 'PWS_5774886D_PN--Premier Wireless Private']
  ]

  type = 'Service-For Sale'
  tax = 'Non-Taxable'
  subsidiary_id = 14

  rep = [['Name', 'UnitPrice', 'Class', 'Acct/GL', 'Type', 'TaxSchedule', 'Subsidiary']]
  code_class.each do |code, cls|
    mrcs.each { |mrc| rep << [ "#{code} #{mrc} MRC", 0, cls, 41102, type, tax, subsidiary_id ] }
    ovgs.each { |ovg| rep << [ "#{code} #{ovg} DATA-OVG", 0, cls, 41103, type, tax, subsidiary_id ] }
    rep << [ "DATA-ROAMING-#{code}", 0, cls, 41103, type, tax, subsidiary_id ]
    rep << [ "#{code}-SCHG-FEE", 0, cls, 41104, type, tax, subsidiary_id ]
    rep << [ "ACTIVATION-#{code}", 0, cls, 41105, type, tax, subsidiary_id ]
    rep << [ "TRMSETUP-#{code}", 0, cls, 41105, type, tax, subsidiary_id ]
    rep << [ "#{code}-SMS", 0, cls, 41106, type, tax, subsidiary_id ]
    commits.each { |c| rep << [ "REV-COMMIT-#{c}", 0, cls, 41111, type, tax, subsidiary_id ] }
  end

  rep << [ "CELL-LOCATE", 0, 'PLAT_SVC--Platform Services', 41110, type, tax, subsidiary_id ]
  rep << [ "CELL-LOCATE-USAGE", 0, 'PLAT_SVC--Platform Services', 41110, type, tax, subsidiary_id ]
  rep << [ "DC-APP", 0, 'PLAT_SVC--Platform Services', 41108, type, tax, subsidiary_id ]
  rep << [ "DC-BYPASS", 0, 'PLAT_SVC--Platform Services', 41108, type, tax, subsidiary_id ]
  rep << [ "DC-CONN", 0, 'PLAT_SVC--Platform Services', 41108, type, tax, subsidiary_id ]
  rep << [ "DC-OPENVPN", 0, 'PLAT_SVC--Platform Services', 41108, type, tax, subsidiary_id ]
  rep << [ "DC-STATIC-IP", 0, 'PLAT_SVC--Platform Services', 41108, type, tax, subsidiary_id ]
  rep << [ "LATTIGO-BASE", 0, 'LATGO_SVC--Lattigo Services', 41107, type, tax, subsidiary_id ]
  rep << [ "LATTIGO-BIZ", 0, 'LATGO_SVC--Lattigo Services', 41107, type, tax, subsidiary_id ]
  rep << [ "LATTIGO-ENPR", 0, 'LATGO_SVC--Lattigo Services', 41107, type, tax, subsidiary_id ]
  rep << [ "PROMO-LATTIGO", 0, 'LATGO_SVC--Lattigo Services', 41107, type, tax, subsidiary_id ]
  rep << [ "PROMO-VPN", 0, 'PLAT_SVC--Platform Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-ETF", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-MISC", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-PROMO", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-DEMO", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-IPSECDIRECT", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]
  rep << [ "OTC-SETUPCHARGE", 0, 'OTHER_SVC--Other Services', 41110, type, tax, subsidiary_id ]

  rep
end
