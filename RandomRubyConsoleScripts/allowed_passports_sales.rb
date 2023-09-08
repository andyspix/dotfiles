users = User.where(organization: 'PWS Sales').joins(:passport).where('passports.name': 'pws_sales').pluck :id
users.each do |uid|
  AllowedPassport.create(user_id: uid, passport_id: 11)
  AllowedPassport.create(user_id: uid, passport_id: 2)
  AllowedPassport.create(user_id: uid, passport_id: 3)
  AllowedPassport.create(user_id: uid, passport_id: 7)
end
