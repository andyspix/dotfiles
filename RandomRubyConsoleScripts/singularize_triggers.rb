shared_trigger_ids = Rule.group(:trigger_id).count.select { |x,y| y > 1 }.map { |x| x[0] }

shared_trigger_ids.each do |t_id|
  org_attrs = Trigger.find(t_id).attributes.except('id')
  rules = Rule.where(trigger_id: t_id)
  # first rule keeps the current trigger,
  rules[1..].each do |r|
    t = Trigger.create org_attrs
    r.update trigger_id: t.id
  end
end

