# the legacy SKU
lat_legacy = Sku.find_by(item: 'LATTIGOPORTAL')

# the new SKUs
lat_base = Sku.find_by(item: 'LATTIGO-BASE')
lat_biz = Sku.find_by(item: 'LATTIGO-BIZ')
lat_enpr = Sku.find_by(item: 'LATTIGO-ENPR')
lat_promo = Sku.find_by(item: 'PROMO-LATTIGO')

# Accounts which are paying for lattigo already just get updated to Enterprise
Feature.where(sku: lat_legacy).update_all sku_id: lat_enpr.id, locked: true

# For unpaying customers with no users add Lattigo Basic
# If they have legacy, replace it with Enterprise, else add the basic portal sku:
no_users = Account.select { |a| a.users.count.zero? }
no_users.each do |a|
  if a.features.where(sku: [lat_enpr, lat_biz, lat_base, lat_legacy]).empty?
    Feature.create(account: a, sku: lat_base, sales_price: 0, unit_count: 1, per_line: false).lock_feature
  end
end

# For Accounts with single 'billing only' users, add basic if they aren't paying for Lattigo
single_bo_users = Account.select { |a| a.users.count == 1 && a.users.first.passport.name == 'account_billing_only' }
single_bo_users.each do |a|
  if a.features.where(sku: [lat_enpr, lat_biz, lat_base, lat_legacy]).empty?
    Feature.create(account: a, sku: lat_base, sales_price: 0, unit_count: 1, per_line: false).lock_feature
  end
end

# unbilled accounts get enterprise if they don't have it:
unbilled = Account.where.not(account_state: 'active').select { |a| a.skus - [lat_base, lat_biz, lat_enpr] == a.skus}
unbilled.each do |a|
  if a.features.where(sku: [lat_enpr, lat_biz, lat_base, lat_legacy]).empty?
    Feature.create(account: a, sku: lat_enpr, sales_price: 49, unit_count: 1, per_line: false).lock_feature
  end
end

# The remainder with active users and Lattigo access but unpaid need special handling...
special = Account.select { |a| a.skus - [lat_base, lat_biz, lat_enpr] == a.skus}

# If the special account has apis enabled or more than 5 users, grant them enterprise lattigo, else biz lattigo, along with a promo so net price is $0, remove promo at future date
special.each do |a|
  sku = a.api_enabled? || a.users.count > 5 ? lat_enpr : lat_biz
  price = a.api_enabled? || a.users.count > 5 ? 49 : 29
  Feature.create(account: a, sku: sku, sales_price: price, unit_count: 1, per_line: false).lock_feature
  Feature.create(account: a, sku: lat_promo, sales_price: -price, unit_count: 1, per_line: false).lock_feature
end

lat_legacy.destroy if Feature.where(sku: lat_legacy).empty?
