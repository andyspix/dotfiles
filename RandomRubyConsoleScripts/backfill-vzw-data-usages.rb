# ssh to the CRON box
# VZW ACCOUNT NUMBERS
# 0442066645-00001
# 0742071985-00001
# 0742006538-00001

cd /home/cmmabee/Work/PWS_Application/CRON/scripts
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742071985-00001 --start_date '2021-03-15' --num_days 24 --upload_daily
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742071985-00001 --start_date '2021-03-01' --num_days 31 --upload_monthly

sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0442066645-00001 --start_date '2021-03-15' --num_days 24 --upload_daily
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0442066645-00001 --start_date '2021-03-01' --num_days 31 --upload_monthly

sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742006538-00001 --start_date '2021-03-15' --num_days 24 --upload_daily
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742006538-00001 --start_date '2021-03-01' --num_days 31 --upload_monthly

sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742071985-00001 --start_date '2021-03-15' --num_days 31 --upload_daily
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0442066645-00001 --start_date '2021-03-15' --num_days 31 --upload_daily
sudo ./rails-upload-verizon-usage-data.pl -conf /home/cmmabee/PerlConfs/production.conf -log STDOUT --account 0742006538-00001 --start_date '2021-03-15' --num_days 31 --upload_daily
