class TraxUpdater
  attr_accessor :esns

  def initialize
    @esns ||= all_esns
  end

  def all_esns # rubocop:disable Metrics/MethodLength
    %w(1274021137 3143034315 3143042863 3143047006 3143048962 3143048991 3143069063 3143069092 4674039403 4674318300 4674318302 4674318307 4674318308 4674318310
       4674318317 4674318321 4674318324 4674318329 4674318335 4674318451 4674318453 4674318461 4674318462 4674318469 4674318470 4674318473 4674318476 4674318477
       4674318479 4674318483 4674318485 4674318486 4674318487 4674318490 4674318495 4674318497 4674318498 4674318500 4674318502 4674318507 4674318508 4674318509
       4674318510 4674318517 4674318520 4674318521 4674318522 4674318523 4674318530 4674318531 4674318532 4674318533 4674318534 4674318535 4674318538 4674318539
       4674318540 4674318541 4674318542 4674318543 4674318545 4674318548 4674318549 4674318550 4674318553 4674318554 4674318555 4674318556 4674318558 4674318559
       4674318561 4674318563 4674319104 4674319156 4674319157 4674319160 4674319165 4674319167 4674319168 4674319170 4674319176 4674319180 4674319185 4674319186
       4674319196 4674319197 4674319200 4674319206 4674319218 4674319222 4674319228 4674319233 4674319241 4674319242 4674319261 4674319263 4674319421 4674319433
       4674319440 4674319448 4674319449 4674319450 4674319452 4674319460 4674319464 4674319465 4674319468 4674428981 4674429105 4674429187 4674429204 4674429212
       4674429213 4674429225 4674429300 4674429318 4674429331 4674429335 4674429336 4674429354 4674429356 4674429371 4674429373 4674429378 4674429382 4674429384
       4674429386 4674429402 4674429407 4674429470 4674429485 4674429490 4674429517 4674429518 4674429519 4674429529 4674429532 4674429538 4674429545 4674429548
       4674429664 4674429666 4674429667 4674429668 4674429677 4674429678 4674429679 4674429681 4674429682 4674429683 4674429687 4674429688 4674429689 4674429691
       4674429692 4674429693 4674429694 4674429695 4674429696 4674429697 4674429699 4674429701 4674429702 4674429703 4674429704 4674429709 4674429711 4674429715
       4674429717 4674429722 4674429728 4674429733 4674429736 4674429750 4674429754 4674429761 4674429769 4674429790 4674429802 4674438168 4674440447 4674440468
       4674441307 4674441504 4674441901 4674441921 4674441927 4674441934 4674441943 4674441978 4674442030 4674442032 4674442039 4674442041 4674442051 4674442061
       4674442066 4674442070 4674442083 4674442089 4674442094 4674442101 4674442115 4674442118 4674442120 4674442122 4674442129 4674442137 4674442139 4674442143
       4674442152 4674442153 4674442160 4674442166 4674442167 4674442171 4674442175 4674442181 4674442185 4674442190 4674442196 4674442197 4674442201 4674442207
       4674442208 4674442209 4674442210 4674442213 4674442218 4674442219 4674442220 4674442226 4674442227 4674442234 4674442240 4674442241 4674442248 4674442250
       4674442254 4674442255 4674442258 4674442262 4674442264 4674442277 4674442283 4674442367 4674442369 4674442370 4674442371 4674442372 4674442374 4674442381
       4674442386)
  end

  def read_device(dev, expected_response)
    agent = LMAgent.new(dev.calamp_device.calamp_id)
    read_response = agent.send_msg(read_parameters_msg(agent, true, true, true, true), dev.ip_address, 20510, 5, 2) # 5s timeout, 2 retries)
    return read_response if read_response.is_a?(String) || read_response&.contents&.response != expected_response
    nil
  end

  def write_device(dev, expected_response)
    agent = LMAgent.new(dev.calamp_device.calamp_id)
    write_response = agent.send_msg(write_parameters_msg(agent), dev.ip_address, 20510, 5, 2) # 5s timeout, 2 retries)
    return write_response if write_response.is_a?(String) || write_response&.contents&.response != expected_response
    nil
  end

  def update_device(dev)
    resp = read_device(dev, expected_read_response1)
    return resp unless resp.nil?

    resp = write_device(dev, expected_write_response)
    return resp unless resp.nil?

    dev.update_attribute :pws_note, 'params written'
    resp = read_device(dev, expected_read_response2)
    return resp unless resp.nil?

    dev.update_attribute :pws_note, 'params confirmed'
    dev.calamp_device.send_peg_action(1, 123)
    nil
  end

  def update_all_devices
    results = []
    Device.joins(:calamp_device).where('calamp_devices.calamp_id': esns).where(pws_note: nil).each { |dev| results << [dev, update_device(dev)] }
    results
  end

  def write_parameters_msg(agent, ip = true, port = true, url0 = true, url1 = true)
    msg = agent.base_message(message_type: 6)
    msg.contents.action = 1
    msg.contents.param_write_requests << write_ip   if ip
    msg.contents.param_write_requests << write_port if port
    msg.contents.param_write_requests << write_url0 if url0
    msg.contents.param_write_requests << write_url1 if url1
    msg
  end

  def write_ip
    wr = LMDirect::ParameterWriteRequest.new
    wr.parameter_id = 768
    wr.payload_length = 5
    wr.payload_data = [172, 31, 1, 87]
    wr.parameter_index = 0
    wr
  end

  def write_port
    wr = LMDirect::ParameterWriteRequest.new
    wr.parameter_id = 769
    wr.payload_length = 3
    wr.payload_data = [80, 40]
    wr.parameter_index = 0
    wr
  end

  def write_url0
    wr = LMDirect::ParameterWriteRequest.new
    wr.parameter_id = 2319
    wr.payload_length = 13
    wr.payload_data = [49, 55, 50, 46, 51, 49, 46, 49, 46, 56, 55, 0]
    wr.parameter_index = 0
    wr
  end

  def write_url1
    wr = LMDirect::ParameterWriteRequest.new
    wr.parameter_id = 2319
    wr.payload_length = 2
    wr.payload_data = [0]
    wr.parameter_index = 1
    wr
  end

  def read_parameters_msg(agent, ip = true, port = true, url0 = true, url1 = true)
    msg = agent.base_message(message_type: 6)
    msg.contents.action = 0
    msg.contents.param_read_requests << read_ip   if ip
    msg.contents.param_read_requests << read_port if port
    msg.contents.param_read_requests << read_url0 if url0
    msg.contents.param_read_requests << read_url1 if url1
    msg
  end

  def read_ip
    rr = LMDirect::ParameterReadRequest.new
    rr.parameter_id = 768
    rr.payload_length = 1
    rr.parameter_index = 0
    rr
  end

  def read_port
    rr = LMDirect::ParameterReadRequest.new
    rr.parameter_id = 769
    rr.payload_length = 1
    rr.parameter_index = 0
    rr
  end

  def read_url0
    rr = LMDirect::ParameterReadRequest.new
    rr.parameter_id = 2319
    rr.payload_length = 1
    rr.parameter_index = 0
    rr
  end

  def read_url1
    rr = LMDirect::ParameterReadRequest.new
    rr.parameter_id = 2319
    rr.payload_length = 1
    rr.parameter_index = 1
    rr
  end

  def expected_read_response1
    [3, 0, 0, 5, 0, 172, 31, 1, 225, 3, 1, 0, 3, 0, 80, 20, 9, 15, 0, 14, 0, 49, 55, 50, 46, 51, 49, 46, 49, 46, 50, 50, 53, 0, 9, 15, 0, 2, 1, 0, 0, 0, 0, 0]
  end

  def expected_read_response2
    [3, 0, 0, 5, 0, 172, 31, 1, 87, 3, 1, 0, 3, 0, 80, 40, 9, 15, 0, 13, 0, 49, 55, 50, 46, 51, 49, 46, 49, 46, 56, 55, 0, 9, 15, 0, 2, 1, 0, 0, 0, 0, 0]
  end

  def expected_write_response
    [0, 0, 0, 0]
  end
end
