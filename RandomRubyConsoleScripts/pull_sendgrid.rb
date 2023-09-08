
url = URI('https://api.sendgrid.com/v3/stats')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

request = Net::HTTP::Get.new(url)
request['authorization'] = "Bearer #{Rails.application.secrets.sendgrid_ops_key}"

response = http.request(request)















