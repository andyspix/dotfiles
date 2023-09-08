# 2900 SIMs
RatePlan.find(2653).devices.where(created_at: Date.parse('Thu, 22 Feb 2023')..Date.parse('Thu, 24 Feb 2023')).map { |d| d.test_ready_waive_mrc(Date.today, 2653) }.tally
