rp = RatePlan.find(2416)
ac = Account.find(319)

nrp = RatePlan.new rp.attributes.except('id', 'name', 'locked')
nrp.name = 'DMG-BOFA-VZW-PUBS-PPU'
nrp.account_id = 319
nrp.save
RatePlan.find(877).devices.each { |d| d.rate_plan = nrp; d.save }
nrp.devices.each { |d| d.backdate_assignment_history(Date.today.beginning_of_month - 1.minute) }



