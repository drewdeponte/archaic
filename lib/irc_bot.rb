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
    end

    bot.start
  end
end

IrcBot::run