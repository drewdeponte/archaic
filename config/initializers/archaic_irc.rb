require 'archaic_config'

Archaic.config do |c|
  c.irc_nick = "dev_arch_bot"
  c.irc_server = "irc.freenode.net"
  c.irc_channels = ["#archaic_dev"]
  c.ticket_url = "http://github.com/cyphactor/archaic/issues#issue/:ticket_id"
  
  c.brew_url = 'http://www.tustinbrewery.com/'
  c.brew_regex = /<div class="brew-name">(.*?)<\/div>/
  c.brews_to_hide = [/guest beers:/, /\*Check out our bottle list/]
  
end
