y = YAML.load File.open('/Users/andyspix/Desktop/fixed2.yaml', 'r')
pdf_free = y.map do |x|
  data = (Hash.from_xml x[2])
  data["DocuSignEnvelopeInformation"].except("DocumentPDFs")
end

statuses = pdf_free.map { |x| x["EnvelopeStatus"]["DocumentStatuses"] }

###############################################################################
###############################################################################
# MSA FIELD MAP:
[{"name"=>"ap_contact_email", "value"=>"andy.spix@pws.bz"},
 {"name"=>"ap_contact_name", "value"=>"Andrew Spix"},
 {"name"=>"ap_contact_phone", "value"=>"650-867-5309"},
 {"name"=>"billing_address", "value"=>"Big Town CA US 95062"},
 {"name"=>"company_name", "value"=>"Andys Test LLC"},
 {"name"=>"company_name_1", "value"=>"Andys Test LLC"},
 {"name"=>"company_name_2", "value"=>"Andys Test LLC"},
 {"name"=>"contact_name", "value"=>"Andrew Spix"},
 {"name"=>"contact_name_1", "value"=>"Andrew Spix"},
 {"name"=>"contact_title", "value"=>"Primary Contact"},
 {"name"=>"contact_title_1", "value"=>"Primary Contact"},
 {"name"=>"customer_ID", "value"=>"739170"},
 {"name"=>"DateSigned", "value"=>"6/26/2023 | 10:32 AM MDT"},
 {"name"=>"email", "value"=>"andy.spix@pws.bz"},
 {"name"=>"phone", "value"=>"650-867-5309"},
 {"name"=>"sales_rep", "value"=>"Charlene Nguyen"},
 {"name"=>"state", "value"=>"CA"},
 {"name"=>"subsidiary", "value"=>"Premier Wireless Solutions"},
 {"name"=>"subsidiary_address", "value"=>"88 Bonaventura Drive San Jose CA United States 95134"},
 {"name"=>"technical_contact_email", "value"=>"andy.spix@pws.bz"},
 {"name"=>"technical_contact_name", "value"=>"Technical Contact 1"},
 {"name"=>"technical_contact_phone", "value"=>"650-867-5309"},
 {"name"=>"Text ac6d6984-8a21-49ff-9cd7-fc028f363065", "value"=>"Premier Wireless Solutions"}]

###############################################################################
###############################################################################
# ADDENDUM FIELD MAP:

[{"name"=>"activation_fee", "value"=>"$1.00"},
 {"name"=>"Carrier", "value"=>"Verizon"},
 {"name"=>"Carrier Rep Email ID", "value"=>"andy.spix@pws.bz"},
 {"name"=>"Carrier Rep Lead ID", "value"=>"1234"},
 {"name"=>"Carrier Rep Name", "value"=>"john person"},
 {"name"=>"commitment_date", "value"=>"9/17/2023"},
 {"name"=>"commitment_type", "value"=>"Revenue"},
 {"name"=>"customer_name", "value"=>"Andys Test LLC"},
 {"name"=>"Data_rate_plan_allwnce", "value"=>"1"},
 {"name"=>"Data_rate_plan_unit", "value"=>"KB"},
 {"name"=>"Individual_line_term", "value"=>"1 Year Term"},
 {"name"=>"lattigo_portal_subs_option", "value"=>"Lattigo Base Plan - $0.00"},
 {"name"=>"left_printed_name", "value"=>"Andys Test LLC : Andrew Spix"},
 {"name"=>"left_printed_title", "value"=>"Primary Contact"},
 {"name"=>"line_revenue_amt", "value"=>"5000"},
 {"name"=>"monthly_access_chrge", "value"=>"3.00"},
 {"name"=>"Network_integration_option", "value"=>"Verizon - Private Static PN"},
 {"name"=>"note", "value"=>"N/A"},
 {"name"=>"open_vpn_client_access", "value"=>"None"},
 {"name"=>"overage_cost", "value"=>"6.00"},
 {"name"=>"overage_cost_unit", "value"=>"GB"},
 {"name"=>"private_network_setup", "value"=>"New Integration - One Time Charge of $299.00 "},
 {"name"=>"public_static_ip_chrge", "value"=>"$2.00 Per SIM"},
 {"name"=>"right_printed_name", "value"=>"Wayne Vandekraak"},
 {"name"=>"sms", "value"=>"MDN MT/MO SMS"},
 {"name"=>"test_ready_mode", "value"=>"Accept"},
 {"name"=>"Text 04d615a7-9af0-4a72-8d21-d41e425af627", "value"=>"Premier Wireless Solutions"}]

###############################################################################
###############################################################################
# SALESFORCE FIELD MAP:

[{"name"=>"ap_contact_email", "value"=>"hank@pacekeeper.golf"},
 {"name"=>"ap_contact_name", "value"=>"Hank Jones"},
 {"name"=>"ap_contact_phone", "value"=>"(919) 354-1001"},
 {"name"=>"billing_address_city df2e9793-0067-44c2-a502-bb34c865ef76", "value"=>"Durham"},
 {"name"=>"billing_address_country 968e10d9-5c52-4de0-9738-32a2fe41dd2d", "value"=>nil},
 {"name"=>"billing_address_state 683e13f4-601b-42f5-a97c-87144039e776", "value"=>"NC"},
 {"name"=>"billing_address_street 0b047a20-07ea-4721-8725-3035fe0a36c4", "value"=>"2 Davis Drive"},
 {"name"=>"billing_address_zip 905433fe-3414-4f77-9bb7-f4e2c926857c", "value"=>"27709"},
 {"name"=>"carrier", "value"=>"Verizon"},
 {"name"=>"carrier_rep_ecode", "value"=>"n/a"},
 {"name"=>"carrier_rep_email", "value"=>"n/a"},
 {"name"=>"carrier_rep_lead_id", "value"=>"n/a"},
 {"name"=>"commitment_date1", "value"=>nil},
 {"name"=>"commitment_line_revenue_amount1", "value"=>nil},
 {"name"=>"commitment_note1", "value"=>nil},
 {"name"=>"contact_phone", "value"=>"(919) 354-1001"},
 {"name"=>"contract_line_commitment_type1", "value"=>"Not Applicable"},
 {"name"=>"customer_information", "value"=>"Existing - Add Rate Plan"},
 {"name"=>"data_rate_plan_allowance", "value"=>"Pay Per Use"},
 {"name"=>"data_rate_plan_unit", "value"=>"Megabyte"},
 {"name"=>"DateSigned", "value"=>"6/23/2023"},
 {"name"=>"individual_line_term", "value"=>"2 Year Term"},
 {"name"=>"international_tier", "value"=>"n/a"},
 {"name"=>"lattigo_portal_subscription", "value"=>"Accept - Lattigo Enterprise $49.00 Per Month"},
 {"name"=>"legal_company_nam 19d15d04-c384-442b-b0d5-f2d9cab96d11", "value"=>"21st Century Creations, LLC"},
 {"name"=>"legal_company_name 0ac7ba48-2772-493d-bbdc-4eb5c96054ee", "value"=>"21st Century Creations, LLC"},
 {"name"=>"legal_company_name 926dae46-0fd4-4f29-b72b-ffee0e03dd8c", "value"=>"21st Century Creations, LLC"},
 {"name"=>"managed_services", "value"=>"n/a"},
 {"name"=>"monthly_access_charge", "value"=>"4.00"},
 {"name"=>"network_integration", "value"=>"Public Network - Public/Dynamic IP"},
 {"name"=>"open_vpn", "value"=>"Decline"},
 {"name"=>"overage_cost", "value"=>".010"},
 {"name"=>"overage_cost_unit", "value"=>"Megabyte"},
 {"name"=>"primary_contact_email", "value"=>"hank@pacekeeper.golf"},
 {"name"=>"primary_contact_name_c", "value"=>"Hank Jones"},
 {"name"=>"primary_contact_title", "value"=>"Founder"},
 {"name"=>"primary_contact_title 3fe8607b-ff0f-4eeb-ae22-e5edb69c6806", "value"=>"Founder"},
 {"name"=>"private_network_engineering_setup", "value"=>"Decline"},
 {"name"=>"professional_services", "value"=>"n/a"},
 {"name"=>"public_static_ip_charge", "value"=>"None"},
 {"name"=>"pws_representative df29228c-635e-49e4-8159-0d6e9f952c19", "value"=>"Robert Smith"},
 {"name"=>"sms_ppu", "value"=>"Block SMS"},
 {"name"=>"software_script_development", "value"=>"n/a"},
 {"name"=>"state_filing_state", "value"=>"North Carolina"},
 {"name"=>"state_filing_type", "value"=>"Corporation"},
 {"name"=>"technical_contact_email", "value"=>"hank@pacekeeper.golf"},
 {"name"=>"technical_contact_name", "value"=>"Hank Jones"},
 {"name"=>"technical_contact_phone", "value"=>"(919) 354-1001"},
 {"name"=>"test_ready_mode", "value"=>"Accept"}]


