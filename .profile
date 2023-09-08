# source /usr/local/share/chruby/chruby.sh
export LOLA_TMP="/home/aspix/.lola"
export LOLA_USER="aspix"
export SSL_CERT_FILE="/usr/local/etc/openssl/cert.pem"
export PERL5LIB=/Users/andyspix/Git_Repository/PWS_application/PerlIncludes/
export EDITOR=nvim
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=
export HISTFILESIZE=

alias lola='cd /Users/andyspix/Git_Repository/lola'
alias teal='cd /Users/andyspix/Git_Repository/TealServerless; make shell'
alias be='bundle exec'
alias kick_dj='pushd /Users/andyspix/Git_Repository/lola/bin; be ./delayed_job -n2 restart; popd'
alias r_c='be rails console'
alias r_d='be rails db -p'
alias r_s='kick_dj; be rails server -b 0.0.0.0'
alias verbose_tests='be rake test TESTOPTS="-v"'

alias rebuild_db='be rake db:drop; be rake db:create; be rake db:migrate; be rake db:seed'

alias rebuild_testdb='testrails; RAILS_ENV=test bin/rails db:drop; RAILS_ENV=test bin/rails db:create; RAILS_ENV=test bin/rails db:migrate; RAILS_ENV=test bin/rails db:seed'

alias testrails='bin/rails db:environment:set RAILS_ENV=test'

alias rebuild_rake='lola; rebuild_testdb; be rake'
alias ll='ls -altr'
alias la='ls -altr'

alias top='glances'
alias gzgrep='zgrep'

alias vim-org='/usr/local/bin/vim'
alias vim='nvim'

shopt -s histappend

alias watch_udp='sudo tcpdump -i eth0 -n udp'

alias dgrep='egrep -i -drecurse'
alias excel='open -a /Applications/Microsoft\ Excel.app/'
alias top='top -o CPU'
alias gitall='git co integration; git pull; git co staging; git pull; git co master; git pull; git co integration'
# TYPOS :-)
alias gti='git'

alias upload_fw="curl -v -u '2c47f830d0112daae35b74f60c1826f7:4f11f18945858476f33e3f2fa5a9deb3bf7b18e8e6f82beff1118dfcd4aaa24a' -X POST -F 'file=@/Users/andyspix/Downloads/RazorShareScooterE300_T_1_0_5.bin' https://portal.pws.bz/v2/device_firmware/upload"
alias list_fw="curl -v -u '2c47f830d0112daae35b74f60c1826f7:4f11f18945858476f33e3f2fa5a9deb3bf7b18e8e6f82beff1118dfcd4aaa24a' -X GET https://portal.pws.bz/v2/device_firmware/list"
alias delete_fw="curl -v -u '2c47f830d0112daae35b74f60c1826f7:4f11f18945858476f33e3f2fa5a9deb3bf7b18e8e6f82beff1118dfcd4aaa24a' -d 'filename=RazorShareScooterE300_T_1_0_4.bin' -X DELETE https://staging.pws.bz/v2/device_firmware/destroy"
alias list_fw_jobs="curl -v -u '2c47f830d0112daae35b74f60c1826f7:4f11f18945858476f33e3f2fa5a9deb3bf7b18e8e6f82beff1118dfcd4aaa24a' -X GET https://portal.pws.bz/v2/device_firmware/jobs/list"
alias install_fw="curl -v -u '2c47f830d0112daae35b74f60c1826f7:4f11f18945858476f33e3f2fa5a9deb3bf7b18e8e6f82beff1118dfcd4aaa24a' -X POST -d 'filename=RazorECOSetSpeed16AV144115190702.bin&device_names[]=&device_names[]=89148000004344388205&device_names[]=89148000004449763435&device_names[]=89148000004385867877' https://portal.pws.bz/v2/device_firmware/jobs/install"
alias tmpcopy='scp web-260-production:/tmp/tmp_csv.csv /tmp'
# ln -s /var/mysql/mysql.sock /tmp/ >& /dev/null

alias demo_test_alert="curl -v -X POST -H 'Content-Type: application/json' -u '95966bc197291970b429dcf31e2f772b:eb980febcd5bb90d4559b68f73156cfe6feedc9e341b3855c0ca52703c6309a4' -d '{"device_names":["204043724647037","89148000004672078295"], "usernames":["andyspix"], "kb_limit":"300000"}'  localhost:3000/v2/device_operations/set_usage_limit"
alias demo_encoding_fail="curl -v -X POST -H 'Content-Type: application/json' -u '✓✓✓:☺☺☺☺☺☺☺' -d '{"device_names":["204043724647037","89148000004672078295"], "usernames":["andyspix"], "kb_limit":"300000"}'  localhost:3000/v2/device_operations/set_usage_limit"
alias demo_encoding_fail="curl -v -X POST -H 'Content-Type: application/json' -u '34c6fd08c4ab578e4f41c96499591cc8e98644f8b9513ee9defb36a91ca8e880:☺' -d '{"device_names":["204043724647037","89148000004672078295"], "usernames":["andyspix"], "kb_limit":"300000"}'  localhost:3000/v2/device_operations/set_usage_limit"
alias prod='ssh web-260-production'
alias staging='ssh web-260-staging'
alias dockerme='lola; cp -fr ~/docker_files/ .'
alias load_minidump="gzcat /Users/andyspix/NOBACKUP/minidump.gz | mysql -uroot --password=password lola_development"
alias load_microdump="mysql -uroot --password=password lola_development < /Users/andyspix/NOBACKUP/microdump"
alias load_razordump="mysql -uroot --password=password lola_development < /Users/andyspix/NOBACKUP/razordump"
alias load_billinghistorydump="mysql -uroot --password=password lola_development < /Users/andyspix/NOBACKUP/billinghistorydump"
alias grab_minidump='scp pws-lola:/tmp/minidump.gz /Users/andyspix/NOBACKUP/minidump.gz; load_minidump'


# FROM PWS-LOLA - Mindumps
# alias minidump="mysqldump -u admin -h lola-production-1.cluster-ro-cpzn56dcxjgb.us-west-1.rds.amazonaws.com --password=stubble!multiple!used1 --single-transaction  --where='1 order by id desc limit 2500000' --ignore_table=lola.production.delayed_jobs --ignore_table=lola_production.warm_messages --ignore_table=lola_production.warm_att_cdrs --ignore_table=lola_production.warm_batch_job_runs --ignore_table=lola_production.warm_daily_data_usages --ignore_table=lola_production.warm_monthly_data_usages --ignore_table=lola_production.warm_device_reports --ignore_table=lola_production.warm_messages --ignore_table=lola_production.warm_sliver_messages --ignore_table=lola_production.ar_internal_metadata --ignore_table lola_production.delayed_jobs --ignore_table lola_production.batch_jobs --ignore_table lola_production.ping_targets --ignore_table lola_production.batch_job_runs lola_production --opt | LANG=C sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | LANG=C sed -e 's/lola_production/lola_development/g' | gzip > /tmp/minidump.gz"
# alias acct_dump="mysqldump -u admin -h lola-production-1.cluster-ro-cpzn56dcxjgb.us-west-1.rds.amazonaws.com --password=stubble!multiple!used1 --single-transaction  lola_production devices rate_plans features one_time_charges contracts skus intacct_configurations accounts carriers assignments assignment_change_histories state_change_histories trm_charge_histories billing_histories daily_data_usages --compatible=mssql --extended-insert=FALSE --opt | gzip > /tmp/acct_dump.gz"
