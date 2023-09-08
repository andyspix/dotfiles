# Make the holding account
ids = Account.where("account_name like 'AES%'").pluck(:id)
acs = Account.where(id: ids)
attrs = acs.last.attributes
attrs.delete('id')
attrs['account_name'] = 'AES-Merged'
attrs['primary_contact'] = 'Tessa Prince'
attrs['primary_email'] = 'service@savingenergyforlife.com'
attrs['primary_phone'] = '(530) 345-6980'
attrs['activation_notes'] = 'Activate all new AES lines in this account.  The deployment end-user should be named in the note field, their phone# in note2, and their email in note3'
merged_ac = Account.new(attrs)
merged_ac.save

Feature.create(account_id: merged_ac.id, sku_id: 500, sales_price: 0.0, per_line: false, unit_count: 1)
merged_ac.reload.features.last.lock_feature

# Make the holding rate plan
rp_attrs = RatePlan.find(2171).attributes
rp_attrs.delete('id')
rp_attrs['account_id'] = merged_ac.id
rp_attrs['name'] = 'AES-Merged-NSA-VZW-PUBD-250MB'
merged_rp = RatePlan.new(rp_attrs)
merged_rp.save

#Update each device to place the account name in note, primary contact and assign to the holding plan
acs.collect(&:devices).flatten.each do |d|
  ced = d.contract_end_date
  d.note = d.account.account_name
  d.note2 = d.account.primary_email.eql?('devnull@pws.bz') ? nil : d.account.primary_email
  d.note3 = d.account.primary_phone.eql?('TBD') ? nil : d.account.primary_phone
  d.rate_plan = merged_rp
  d.save
  d.update contract_end_date: ced
end

Account.find(1309).users.last.update account_id: merged_ac.id
Account.find(1316).users.last.destroy

acs.each do |a|
  a.assignment_change_histories&.update_all account_id: merged_ac.id, rate_plan_id: merged_rp.id
  a.billing_histories&.destroy_all
  a.invoices&.destroy_all
  a.detail_sheets&.destroy_all
  a.features.first&.unlock_feature
  a.features.first&.destroy
  a.sales_contracts.update_all account_id: merged_ac.id
  a.rate_plans.last&.unlock_rate_plan
  a.rate_plans.last&.destroy
end

acs.reload.map(&:deletion_blockers)

acs.destroy_all


