require 'rubygems'
require 'irb/completion'

begin
  require 'interactive_editor'
rescue  LoadError => err
  warn "Couldn't load interactive_editor: #{err}"
end

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue  LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end

begin
  require 'factory_girl_rails'
rescue  LoadError => err
  warn "Couldn't load factory girl: #{err}"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:EVAL_HISTORY] = 5000
IRB.conf[:SAVE_HISTORY] = 5000
IRB.conf[:HISTORY_FILE] = File::expand_path("~/.irbhistory")
