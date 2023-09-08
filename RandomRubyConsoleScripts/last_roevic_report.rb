bofa = RatePlan.find(2653).devices;0
wells = RatePlan.find(2521).devices;0

report = [%w(DeviceName StartDate StillInTRM? ForcedTrmEndDate CommissionIssuedDate CommissionIssuedAmount CommissionIssuedTo)]
bofa_r = bofa.map do |d|
  start = d.assignment_change_histories.where(rate_plan_id: 2653).last.created_at
  [d.device_name,
   start,
   d.test_ready_waive_mrc(Date.today, 2653),
   start + 5.months,
   d.commission_histories.last&.created_at,
   d.commission_histories.last&.amount,
   d.commission_histories.last&.issued_to
  ]
end;0

wells_r = wells.map do |d|
  start = d.assignment_change_histories.where(rate_plan_id: 2521).last.created_at
  [d.device_name,
   start,
   d.test_ready_waive_mrc(Date.today, 2521),
   start + 5.months,
   d.commission_histories.last&.created_at,
   d.commission_histories.last&.amount,
   d.commission_histories.last&.issued_to
  ]
end;0

tmp_csv report + bofa_r + wells_r


