def update_razors
  unexpected_read = {}
  unexpected_write = {}
  all = Account.find(816).devices.where.not(note: nil)
  updated = Account.find(816).devices.where(note3: '60s')
  (all - updated).each do |dev|
    next if dev.note3 == '60s'
    (unexpected_read[dev.id] = 'No CalampId' && next) if dev.calamp_id.nil?
    agent = LMAgent.new(dev.calamp_device.calamp_id)
    read_msg = agent.read_parameter_msg(265, 1, 0)
    read_response = agent.send_msg(read_msg, dev.ip_address, 20510, 5, 2)
    if read_response.is_a? String
      unexpected_read[dev.id] = read_response
    elsif read_response.contents.response == [1, 9, 0, 5, 0, 0, 0, 0, 120, 0, 0, 0, 0]
      write_msg = agent.write_parameter_msg(265, 0, [0, 0, 0, 60])
      write_response = agent.send_msg(write_msg, dev.ip_address, 20510, 5, 2)
      if write_response.contents.response == [0, 0, 0, 0]
        dev.update_attribute :note3, '60s'
      else
        unexpected_write[dev.id] = write_response
      end
    else
      unexpected_read[dev.id] = read_response
    end
  end
  [unexpected_read, unexpected_write]
end

5.times do
  update_razors
  sleep 60
end
