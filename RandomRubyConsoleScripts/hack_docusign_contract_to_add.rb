d = DocusignNotification.find(1182)
d = DocusignNotification.find(1183)

d.update content: d.content.gsub('New Account', 'Existing - add rate plan')
