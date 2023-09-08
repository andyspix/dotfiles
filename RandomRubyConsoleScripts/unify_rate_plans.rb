Account.find(1).devices.find_each { |d| d.rate_plan = RatePlan.find_by(name: '(PWS_DEFAULT)') }
Account.find(49).devices.find_each { |d| d.rate_plan = RatePlan.find_by(name: '(PWS_RETIRED)') }

Account.find(1).rate_plans   # Check each and delete if empty
Account.find(2).rate_plans   # Check each and delete if empty
Account.find(49).rate_plans  # Check each and delete if empty
