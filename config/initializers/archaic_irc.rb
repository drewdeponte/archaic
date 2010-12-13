require 'archaic_config'

Archaic.config do |c|
  c.irc_nick = "dev_arch_bot"
  c.irc_server = "irc.freenode.net"
  c.irc_channels = ["#archaic_dev"]
  c.ticket_url = "http://github.com/cyphactor/archaic/issues#issue/:ticket_id"
end