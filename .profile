export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias lola='cd /Users/andyspix/Git_Repository/lola'
alias newsun='cd /Users/andyspix/Git_Repository/newsuntechnologies/featherlink'
alias r_c='rails console'
alias r_d='rails db -p'
alias r_s='rails server -b 0.0.0.0'

alias rebuild_rake='RAILS_ENV=test rake db:drop; RAILS_ENV=test rake db:create; RAILS_ENV=test rake db:migrate; RAILS_ENV=test rake db:seed; rake'
alias ll='ls -altr'
