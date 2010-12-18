require 'archaic_config'

# Set all the hard coded defaults
Archaic.config do |c|
  c.irc_nick = "steve_arch_bot"
  c.irc_server = "irc.freenode.net"
  c.irc_channels = ["#steve_archaic_dev"]
  c.ticket_url = "http://github.com/cyphactor/archaic/issues#issue/:ticket_id"
  
  c.brew_url = 'http://www.tustinbrewery.com/'
  c.brew_regex = /<div class="brew-name">(.*?)<\/div>/
  c.brews_to_hide = [/guest beers:/, /\*Check out our bottle list/]
end

# Provide an opportunity for the defaults and additional configs to be set
custom_conf = File.expand_path('../../ArchaicConfig.rb', __FILE__)
if File.exists?(custom_conf)
  require custom_conf
end
