class TraxReader
  def read_device(dev, tries = 2, param = 0)
    agent = LMAgent.new(dev.calamp_device.calamp_id)
    agent.send_msg(read_parameters_msg(agent, param), dev.ip_address, 20510, 5, tries) # 5s timeout, 2 retries)
    # agent.send_msg(read_all_sreg_msg(agent), dev.ip_address, 20510, 5, tries) # 5s timeout, 2 retries)
  end

  def read_sreg(param)
    rr = LMDirect::ParameterReadRequest.new
    rr.parameter_id = 3072
    rr.payload_length = 1
    rr.parameter_index = param
    rr
  end

  def read_parameters_msg(agent, param)
    msg = agent.base_message(message_type: 6)
    msg.contents.action = 0
    msg.contents.param_read_requests << read_sreg(param)
    msg
  end

  def read_all_sreg_msg(agent)
    msg = agent.base_message(message_type: 6)
    msg.contents.action = 0
    msg.contents.param_read_requests << read_sreg(0)
    msg.contents.param_read_requests << read_sreg(1)
    msg.contents.param_read_requests << read_sreg(2)
    msg.contents.param_read_requests << read_sreg(3)
    msg.contents.param_read_requests << read_sreg(4)
    msg.contents.param_read_requests << read_sreg(5)
    msg.contents.param_read_requests << read_sreg(6)
    msg.contents.param_read_requests << read_sreg(7)
    msg.contents.param_read_requests << read_sreg(8)
    msg.contents.param_read_requests << read_sreg(9)
    msg.contents.param_read_requests << read_sreg(10)
    msg.contents.param_read_requests << read_sreg(11)
    msg.contents.param_read_requests << read_sreg(12)
    msg.contents.param_read_requests << read_sreg(13)
    msg.contents.param_read_requests << read_sreg(14)
    msg.contents.param_read_requests << read_sreg(15)
    msg.contents.param_read_requests << read_sreg(16)
    msg.contents.param_read_requests << read_sreg(17)
    msg.contents.param_read_requests << read_sreg(18)
    msg.contents.param_read_requests << read_sreg(19)
    msg.contents.param_read_requests << read_sreg(20)
    msg.contents.param_read_requests << read_sreg(21)
    msg.contents.param_read_requests << read_sreg(22)
    msg.contents.param_read_requests << read_sreg(23)
    msg.contents.param_read_requests << read_sreg(24)
    msg.contents.param_read_requests << read_sreg(25)
    msg.contents.param_read_requests << read_sreg(26)
    msg.contents.param_read_requests << read_sreg(27)
    msg.contents.param_read_requests << read_sreg(28)
    msg.contents.param_read_requests << read_sreg(29)
    msg.contents.param_read_requests << read_sreg(30)
    msg.contents.param_read_requests << read_sreg(31)
    msg.contents.param_read_requests << read_sreg(32)
    msg.contents.param_read_requests << read_sreg(33)
    msg.contents.param_read_requests << read_sreg(34)
    msg.contents.param_read_requests << read_sreg(35)
    msg.contents.param_read_requests << read_sreg(36)
    msg.contents.param_read_requests << read_sreg(37)
    msg.contents.param_read_requests << read_sreg(38)
    msg.contents.param_read_requests << read_sreg(39)
    msg.contents.param_read_requests << read_sreg(40)
    msg.contents.param_read_requests << read_sreg(41)
    msg.contents.param_read_requests << read_sreg(42)
    msg.contents.param_read_requests << read_sreg(43)
    msg.contents.param_read_requests << read_sreg(44)
    msg.contents.param_read_requests << read_sreg(45)
    msg.contents.param_read_requests << read_sreg(46)
    msg.contents.param_read_requests << read_sreg(47)
    msg.contents.param_read_requests << read_sreg(48)
    msg.contents.param_read_requests << read_sreg(49)
    msg.contents.param_read_requests << read_sreg(50)
    msg.contents.param_read_requests << read_sreg(51)
    msg.contents.param_read_requests << read_sreg(52)
    msg.contents.param_read_requests << read_sreg(53)
    msg.contents.param_read_requests << read_sreg(54)
    msg.contents.param_read_requests << read_sreg(55)
    msg.contents.param_read_requests << read_sreg(56)
    msg.contents.param_read_requests << read_sreg(57)
    msg.contents.param_read_requests << read_sreg(58)
    msg.contents.param_read_requests << read_sreg(59)
    msg.contents.param_read_requests << read_sreg(60)
    msg.contents.param_read_requests << read_sreg(61)
    msg.contents.param_read_requests << read_sreg(62)
    msg.contents.param_read_requests << read_sreg(63)
    msg
  end
end
