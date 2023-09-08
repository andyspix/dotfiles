startpoint = RazorMessage.first.id
endpoint = RazorMessage.where(created_at: Date.today.days_ago(34)).first.id
i = startpoint
while i < endpoint
  i += 1000000
  t = Time.now
  print "nuking to #{i} ... "
  RazorMessage.where('id < ?', i).delete_all
  puts "#{Time.now - t} seconds"
  sleep 100
end
