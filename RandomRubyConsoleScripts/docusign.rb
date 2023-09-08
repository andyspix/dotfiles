has_content = DocusignNotification.where.not(content: nil).pluck :id, :raw
empty_content = DocusignNotification.where(content: nil).pluck :id, :raw

has_map = has_content.map { |r| [r[0], Hash.from_xml(r[1])['DocuSignEnvelopeInformation']['EnvelopeStatus']] }.select { |h| h[1]['Status'].eql? 'Completed' }
no_map = empty_content.map { |r| [r[0], Hash.from_xml(r[1])['DocuSignEnvelopeInformation']['EnvelopeStatus']] }.select { |h| h[1]['Status'].eql? 'Completed' }


# Compare 784 (good) vs 452 (bad)

good = has_map.last[1]
bad  = no_map.last[1]

# good.keys - bad.keys
# []
#
# good['RecipientStatuses']['RecipientStatus'].count
# 4
# bad['RecipientStatuses']['RecipientStatus'].count
# 3

completed = DocusignNotification.all.select { |dn| JSON.parse(dn.content)['details']['completed_contract'] }
completed.map! { |c| JSON.parse c.content }
new_act = completed.select { |a| ['New Account'].include? a['form_fills']['customer_information'] }
new_act_names = new_act.map { |na| na['form_fills']['legal_company_name'] }

existing_account_names = Account.pluck(:account_name)
add_rtp = completed.select { |a| ['Existing - Add Rate Plan'].include? a['form_fills']['customer_information'] }

add_rtp_names = add_rtp.map { |na| na['form_fills']['legal_company_name'] }

