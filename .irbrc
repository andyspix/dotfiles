require 'irb/completion'
require 'rubygems'

# Define some damn convenient helpers
def tmp_csv(data, outfile = '/tmp/tmp_csv.csv')
  File.open(outfile, 'w') { |f| f.write(data.inject([]) { |a, e| a << CSV.generate_line(e) }.join('')) }
end

def tmp_yaml(data, outfile = '/tmp/tmp_yaml.yaml')
  File.open(outfile, 'w') { |file| file.write data.to_yaml }
end

def read_csv(infile)
  require 'csv'
  quote_chars = %w(" | ~ ^ & *)
  begin
    csv_text = File.open(infile, 'r:bom|utf-8')
    CSV.parse(csv_text, headers: true, quote_char: quote_chars.shift, liberal_parsing: true)
  rescue CSV::MalformedCSVError
    quote_chars.empty? ? raise : retry
  end
end

def af(x)
  Account.where("account_name like '%#{x}%'")
end

def factorybot
  require 'factory_bot'
  FactoryBot.find_definitions
  include FactoryBot::Syntax::Methods
end

def history
  puts File.read("#{ENV['HOME']}/.irbhistory");
end

def rps(x)
  af(x).first.rate_plans.map { |r| [r.devices.count, r.name, r.id] }.sort_by { |x| x[0] }.map{ |x| x.join(' : ') }
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:EVAL_HISTORY] = 5000
IRB.conf[:SAVE_HISTORY] = 5000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irbhistory')
IRB.conf[:USE_AUTOCOMPLETE] = false


def humanize(x)
  helper.number_to_human_size(x)
end

def andy
  User.find_by(username: 'pws_developer')&.update_column(:multifactor_required, false)
  User.find(69)&.update_column(:multifactor_required, false)
  bowdlerize
end

def bowdlerize
  Account.all.each do |ac|
    ac.update primary_contact: Faker::Hipster.words.join(' ')
    ac.update primary_phone: Faker::PhoneNumber.phone_number
    ac.update primary_email: 'devnull@pws.bz'
    ac.update billing_contact: Faker::Hipster.words.join(' ')
    ac.update billing_phone: nil
    ac.update billing_address_1: nil
    ac.update billing_address_2: nil
    ac.update billing_city: nil
    ac.update billing_state: nil
    ac.update billing_country: nil
    ac.update billing_zip: nil
    ac.update notification_emails: nil
  end
  Sublet.destroy_all
  User.where.not(id: 69).each do |u|
    u.update stripe_customer_id: nil, organization: nil, full_name: nil, phone: nil, email: 'devnull@pws.bz', username: User.unique_username(Faker::Hipster.words(number: 1).first), encrypted_password: 'bogus'
  end
end

def log_level(level = 1)
  ActiveRecord::Base.logger.level = level
end
log_level
