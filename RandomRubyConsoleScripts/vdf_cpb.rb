attr = CarrierPlanBundle.find(64).attributes
attr['ips_are_static'] = true
attr['name'] = "Vodafone Public Static with SMS - Manual"
attr.delete('id')
attr.delete('locked')
c = CarrierPlanBundle.create attr

attr = CarrierPlanBundle.find(69).attributes
attr['ips_are_static'] = true
attr['name'] = "Vodafone Private Static with SMS - Manual"
attr.delete('id')
attr.delete('locked')
c = CarrierPlanBundle.create attr

attr = CarrierPlanBundle.find(70).attributes
attr['ips_are_static'] = true
attr['name'] = "Vodafone Public Static no SMS - Manual"
attr.delete('id')
attr.delete('locked')
c = CarrierPlanBundle.create attr

attr = CarrierPlanBundle.find(71).attributes
attr['ips_are_static'] = true
attr['name'] = "Vodafone Private Static no SMS - Manual"
attr.delete('id')
attr.delete('locked')
c = CarrierPlanBundle.create attr

