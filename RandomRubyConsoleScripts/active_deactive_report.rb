acc = Account.find(1028)
rps = acc.rate_plans.pluck(:id)
devs = AssignmentChangeHistory.where(rate_plan_id: rps).pluck(:device_id) + AssignmentChangeHistory.where(previous_rate_plan_id: rps).pluck(:device_id)

Device.where(id: devs).map do |d|
  [ d.device_name,
    d.imei,
    d.created_at,
    d.assignment_change_histories.where.not(rate_plan_id: [nil, RatePlan.default.id, RatePlan.duplicate.id, RatePlan.inventory.id, RatePlan.retired.id]).first.created_at,
    d.state_change_histories.where(state: 'deactive').last&.created_at,
    d.contract_end_date
  ]
end


