o = Order.create(account: Account.default_account, user: User.find_by(username: 'pws_developer'), type: 'ActivateOrder', status: :new)
od = OrderDetail.create(order: o, external: true, event: { description: 'Activation sent to Carrier', device: { iccid: 12345, imei: 'abcde' } })
od = OrderDetail.create(order: o, external: true, event: { description: 'Carrier Response', response: 'Device is Unavailable' })
od = OrderDetail.create(order: o, event: { description: 'Carrier Response', response: { error_code: 123, iccid: 12345 } })
od = OrderDetail.create(order: o, external: true, event: 'Just a String')
od = OrderDetail.create(order: o, event: ['An array of things', 'Yep - an array', 8675309])
od = OrderDetail.create(order: o, event: {status: 'Complete', completed_at: Time.now, details: ['A bunch of junk', 'Sent from a Carrier', {wow: :a_hash}]})
od = OrderDetail.create(order: o, event: {Errors: ['Andy wrote it', "We're all doomed"]})


o = Order.create(account: Account.default_account, user: User.find_by(username: 'pws_developer'), type: 'ActivateOrder', status: :new)
od = OrderDetail.create(order: o, external: true, event: { description: 'Activation sent to Carrier', device: { iccid: 12345, imei: 'abcde' } })
od = OrderDetail.create(order: o, external: true, event: { description: 'Carrier Response', response: 'Device is Unavailable' })
od = OrderDetail.create(order: o, event: { description: 'Carrier Response', response: { error_code: 123, iccid: 12345 } })
od = OrderDetail.create(order: o, external: true, event: 'Just a String')
od = OrderDetail.create(order: o, event: ['An array of Strings'])
od = OrderDetail.create(order: o, event: {status: 'Complete', completed_at: Time.now, details: ['A bunch of junk', 'Sent from a Carrier', {wow: :this_works?}]})

o = Order.create(account: Account.last, user: User.find_by(username: 'pws_developer'), type: 'ActivateOrder', status: :new)
od = OrderDetail.create(order: o, external: true, event: { description: 'Activation sent to Carrier', device: { iccid: 12345, imei: 'abcde' } })
od = OrderDetail.create(order: o, external: true, event: { description: 'Carrier Response', response: 'Device is Unavailable' })
od = OrderDetail.create(order: o, event: { description: 'Carrier Response', response: { error_code: 123, iccid: 12345 } })
od = OrderDetail.create(order: o, external: true, event: 'Just a String')


o = Order.create(account: Account.third, user: Account.third.users.first, type: 'ActivateOrder', status: :new)

o = Order.create(account: Account.default_account, user: User.find_by(username: 'pws_developer'), type: 'SwapDeviceOrder', status: :new)

o = Order.create(account: Account.last, user: Account.last.users.first, type: 'ActivateOrder', status: :new)
od = OrderDetail.create(order: o, external: true, event: { description: 'Activation sent to Carrier', device: { iccid: 12345, imei: 'abcde' } })
od = OrderDetail.create(order: o, external: true, event: { description: 'Carrier Response', response: 'Device is Unavailable' })
od = OrderDetail.create(order: o, event: { description: 'Carrier Response', response: { error_code: 123, iccid: 12345 } })
od = OrderDetail.create(order: o, external: true, event: 'Just a String')


