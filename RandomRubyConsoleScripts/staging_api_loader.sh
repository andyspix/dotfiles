#!/bin/bash

for i in {1..3600}
do
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -X GET "https://staging.lattigo.com/v2/devices/89148000004565721076"
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -X GET "https://staging.lattigo.com/v2/devices/89148000004566297290"
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -X GET "https://staging.lattigo.com/v2/devices/89148000004566173756"
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -X GET "https://staging.lattigo.com/v2/devices"
	sleep 0.2
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -d 'field_name=note' -d "note= $i loops" -X PUT "https://staging.lattigo.com/v2/devices/89148000004566173756/note"
  curl -v -u 'db_migrate:16e8291b0802478c117481be94660715c0ede87270fc0a96bdc869e81d321459' -X GET "https://staging.lattigo.com/v2/devices/89148000004566173756"
	sleep 1
done
