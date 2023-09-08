# For Business Internet form extraction:
>> dn.hashed_envelope['RecipientStatuses']['RecipientStatus'].first['FormData']
=> {"xfdf"=>{"fields"=>{"field"=>[{"name"=>"EquipmentIDs", "value"=>"IMEI: 862515043168206 ICCID: 89148000008229644855\n"}, {"name"=>"MobileNumber", "value"=>"5105523456"}]}}}

>> dn.hashed_envelope['RecipientStatuses']['RecipientStatus'].second['FormData']
=> {"xfdf"=>{"fields"=>{"field"=>[{"name"=>"FullName", "value"=>"Roevic Garingan"}, {"name"=>"Company", "value"=>"Kdkdkd"}, {"name"=>"Title", "value"=>"Djdndn"}, {"name"=>"Text 25fae63d-dd5e-4296-9d02-9492dd524268", "value"=>"395959594"}, {"name"=>"DateSigned", "value"=>"9/7/2022"}]}}}

