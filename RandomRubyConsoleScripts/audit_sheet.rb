include ActionView::Helpers::NumberHelper
def master_header
  [[
    '(ACT) Account Name', '(ACT) Account State', '(ACT) Created At', '(ACT) Feature Description', '(ACT) Feature Price', '(ACT) Feature Units',
    '(RP) Plan Name', '(RP) Current Device Count', '(RP) Monthly Rate per Device', '(RP) Plan Size kB', '(RP) Plan Size SMS',
    '(RP) Overage Cost per unit', '(RP) Overage Unit', '(RP) SMS Base Charge', '(RP) SMS Unit Charge',
    '(RP) Activation Charge', '(RP) Deactivation (ETF) Charge', '(RP) Software & Services', '(RP) Additional Features',
#    '(USR) UserName', '(USR) Email', '(USR) Permissions', '(USR) Active?'
  ]]
end

def account_data(account, list)
  account.features.each do |f|
    per_line = f.per_line ? ' / line' : ''
    count = f.unit_count.nil? ? 1 : f.unit_count
    list << [account.account_number_name, account.account_state, account.created_at, f.sku.description, number_to_currency(f.sales_price).to_s + per_line, count]
  end
  list
end

def rate_plans_data(account, list)
  account.rate_plans.each do |rp|
    list << [account.account_number_name, account.account_state, account.created_at,
             '', '', '', rp.name, rp.devices.count,
             number_to_currency(rp.monthly_rate_per_device),
             number_with_delimiter(rp.plan_size_kb_per_device),
             rp.plan_size_sms,
             number_to_currency(rp.price_ovg_data_unit, precision: 10),
             number_to_human_size(rp.ovg_data_unit),
             number_to_currency(rp.sms_base_charge),
             number_to_currency(rp.sms_unit_charge),
             number_to_currency(rp.activation_charge),
             number_to_currency(rp.deactivation_charge),
             number_to_currency(rp.service_charge),
             additional_features(rp)]
  end
  list
end

def users_data(account, list)
  User.where(account_id: account.id).each do |usr|
    list << [account.account_number_name, account.account_state, account.created_at,
             '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',
             usr.username,
             usr.email,
             usr.passport.name,
             usr.active ? 'Active' : 'Disabled']
  end
  list
end

def additional_features(rate_plan)
  trm = Contract.find_by(sku_id: 195, rate_plan_id: rate_plan.id)
  no_sms = Contract.find_by(sku_id: 204, rate_plan_id: rate_plan.id)
  static_ip = Contract.find_by(sku_id: 74, rate_plan_id: rate_plan.id)
  result = ''
  result += "TRM: #{trm.sales_price} " if trm.present?
  result += "NOSMS: #{no_sms.sales_price} " if no_sms.present?
  result += "STATICIP: #{static_ip.sales_price}" if static_ip.present?
  result
end

def build_csv
  list = master_header
  Account.find(Account.all.each.map{ |a| [a.id, a.devices.count] }.sort_by { |x| -x[1] }.map { |x| x[0] }).each do |act|
    list = account_data(act, list)
    list = rate_plans_data(act, list)
    # list = users_data(act, list)
  end
  list
end
