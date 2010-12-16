require 'cinch'
require 'date'

module IrcBot
  def self.run
    bot = Cinch::Bot.new do
      configure do |c|
        c.nick = Archaic::CONFIG.irc_nick
        c.server = Archaic::CONFIG.irc_server
        c.channels = Archaic::CONFIG.irc_channels       
      end

      on :message, /.+/ do |m|
        Message.create!(:body => m.message, :author => m.user.nick)
      end
      
      on :message, /.*#(\d+).*/ do |m, ticket_num|
        tick_url_template = Archaic::CONFIG.ticket_url
        if tick_url_template
          tick_url = tick_url_template.gsub(/:ticket_id/, "#{ticket_num}")
          m.reply "#{tick_url}"
        end
      end

      on :message, "weeknum" do |m|
        d = Date.today
        m.reply "#{m.user.nick} the current week number is #{d.cweek()}"
      end
      
      on :message, "tbc" do |m|
      	require 'net/http'
				url = URI.parse(Archaic::CONFIG.brew_url)
				resp = Net::HTTP.get(url)
		
				brews = resp.scan(Archaic::CONFIG.brew_regex)
		
				# scan returns an array of arrays, and we just want the first capture group
				brews = brews.collect { |b| b[0] }
		
				# remove hidden brews
				brews_to_hide = Archaic::CONFIG.brews_to_hide
				brews = brews.select do |b|
					!brews_to_hide.any? { |hidden_brew| b.match(hidden_brew) }
				end
				
				brews.each do |b|
					m.reply b
				end
				
      end
      
    end

    bot.start
  end
end

IrcBot::run
