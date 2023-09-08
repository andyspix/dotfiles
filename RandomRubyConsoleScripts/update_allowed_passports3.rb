p = Passport.create name: 'pws_admin_with_commissions'
Passport.find_by(name: 'pws_admin').roles.pluck(:name).map(&:to_sym).each { |x| p.add_role x }
p.add_role :commissions_editor
Passport.find_by(name: 'pws_developer').add_role :commissions_editor

User.find(143).update passport: p

# Devs, Gregg, Roevic - can pretend to be commissions_editors
[69, 71, 73, 74, 761, 143].each { |uid| AllowedPassport.create(user_id: uid, passport_id: 14) }

