# Devs, Gregg - can pretend to be activations/basic
[69, 71, 73, 74, 761].each { |uid| [12,13].each { |x| AllowedPassport.create(user_id: uid, passport_id: x) }  }

# Roevic, Gere, Bae
[72, 143].each { |uid| [12,13].each { |x| AllowedPassport.create(user_id: uid, passport_id: x) }  }

# Ben, Mark, Marius
[399, 659, 671].each { |uid| [12,13].each { |x| AllowedPassport.create(user_id: uid, passport_id: x) }  }

# Update billing_only to basic as needed
users = User.select { |u| u.passport.id == 6 }
basics = users.select { |u| u.account.features.where(sku_id: 500).present? }
basics.each { |u| u.passport_id = 12; u.save }
basics.each { |u| u.passport = Passport.find(12); u.save }
