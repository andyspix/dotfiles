purge_ids = Device.where(id: DeviceTrigger.pluck(:target_id).uniq).where(state: ['deactive', 'retired', 'terminated', 'activation_failed', 'Line Swapped']).pluck(:id)
trigger_ids = Trigger.where(target_id: purge_ids).pluck(:id)
Rule.where(trigger_id: trigger_ids).destroy_all




