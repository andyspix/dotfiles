def update_me(iccid, carrier_account)
  client ||= Aws::SQS::Client.new
  command = {
    command: 'UpdateDeviceInformation',
    args: {
      carrier: carrier_account.carrier.carrier_code,
      carrier_account_number: carrier_account.carrier_account_number,
      device_id: iccid,
      lola_device_id: 999999999,
      type: 'iccid'
    }
  }.to_json

  client.send_message(queue_url: client.get_queue_url(queue_name: Rails.configuration.x[:aws][:api_requests_queue]).queue_url, message_body: command)
end
