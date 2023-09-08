require 'aws-sdk-ec2'
class AwsUtils
  def initialize
    @ec2 = Aws::EC2::Resource.new(region: 'us-west-1')
    @logger = Rails.logger
  end

  def wait_for_instances(state, ids)
    @ec2.wait_until(state, instance_ids: ids)
    puts "Success: #{state}."
  rescue Aws::Waiters::Errors::WaiterFailed => error
    puts "Failed: #{error.message}"
  end

  def stop_all_staging
    # OLD:
    # staging_boxes.each { |i| stop_instance(i) }
    inst_ids = staging_boxes.map(&:id)
    @ec2.stop_instances({ instance_ids: inst_ids })
    wait_for_instances(@ec2, :instance_stopped, inst_ids)
  end

  def start_all_staging
    # OLD:
    # staging_boxes.each { |i| stop_instance(i) }
    inst_ids = staging_boxes.map(&:id)
    @ec2.start_instances({ instance_ids: inst_ids })
    wait_for_instances(@ec2, :instance_stopped, inst_ids)
  end

  def staging_boxes
    @ec2.instances(filters: [f_web, f_staging])
  end

  def f_web
    { name: 'tag:role', values: ['web'] }
  end

  def f_staging
    { name: 'tag:tier', values: ['staging'] }
  end

  def stop_instance(inst)
    return 'Instance does not exist' unless inst.exists?

    case inst.state.code
    when 48  # terminated
      return "#{inst.id} is terminated, so you cannot stop it"
    when 64  # stopping
      return "#{inst.id} is stopping, so it will be stopped in a bit"
    when 80  # stopped
      return "#{inst.id} is already stopped"
    else
      inst.stop
    end
  end

  def start_instance(inst)
    return 'Instance does not exist' unless inst.exists?
    case inst.state.code
    when 0  # pending
      return "#{inst.id} is pending, so it will be running in a bit"
    when 16 # started
      return "#{inst.id} is already started"
    when 48 # terminated
      return "#{inst.id} is terminated, so you cannot start it"
    else
      inst.start
    end
  end
end
