mobile_ids = RazorMessage.where(message_type: 2).where(fix_status: [32, 33, 34, 35, 36, 37, 38, 39, 44, 48, 49, 50, 51, 52, 53, 54]).pluck(:mobile_id).uniq

header = ['Time of Fix', 'Fix Status', 'Raw']
ids = []
mobile_ids.each do |m| 
  rms = RazorMessage.where(mobile_id: m, message_type: 2).order(:time_of_fix).pluck(:time_of_fix, :fix_status, :raw)
  quarter = (rms.length * 0.25).to_i
  first = rms.first(quarter)
  last = rms.last(quarter)
  middle = rms - rms_first - rms_last
  a = middle.select {|x| x[1].to_i > 31 && x[1].to_i < 64 }.count > 100
  b = last.select {|x| x[1].to_i < 2 }.count > 50
  c = first.select {|x| x[1].to_i < 2 }.count > 50
  ids << m if a && b && c
end 

ids = ["4674220358", "4674220139", "4674219170", "4674220255", "4674220248", "4674220590", "4674220315", "4674219761", "4674219920", "4674219126", "4674219192", "4674219692", "4674219918", "4674219723", "4674219718", "4674220305", "4674219904", "4674220357", "4674219121", "4674219832", "4674219694", "4674219753", "4674220175", "4674219803", "4674219719", "4674220396", "4674219935", "4674220388", "4674220107", "4674220148", "4674220087", "4674220015", "4674219940", "4674220264", "4674220086", "4674219889", "4674220080", "4674245115", "4674244555", "4674245904", "4674245907", "4674245909", "4674245906", "4674245905", "4674244967", "4674245162", "4674245814", "4674245900", "4674245908", "4674245129"] 

output = [['MobileId', 'Time of Fix', 'Fix Status', 'Raw']]
ids.each do |m| 
  RazorMessage.where(mobile_id: m, message_type: 2).order(:time_of_fix).pluck(:time_of_fix, :fix_status, :raw).each do |x|
    output << [m, x[0], x[1], x[2]]
  end
end

