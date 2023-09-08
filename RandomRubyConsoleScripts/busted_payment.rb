

session_id = 'cs_live_a1GH9QUQ8jl8swCnXi9Gvpz09tyNmd06Hj3xKLvuPy0weCyc9jM7fzDgee'
tranid = 'INV513351'
int_id = 6592096
session = Stripe::Checkout::Session.retrieve(session_id)
ph = PaymentHistory.where(stripe_session_id: session_id, netsuite_tranid: tranid, netsuite_internalid: int_id).last
ph.reflect_payment_in_netsuite(session[:payment_intent], Date.parse('may 17, 2023'))
