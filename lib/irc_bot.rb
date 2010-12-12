require 'cinch'
require 'date'

module IrcBot
  def self.run
    bot = Cinch::Bot.new do
      configure do |c|
        c.nick = "dev_arch_bot"
        c.server = "irc.freenode.net"
        c.channels = ["#realpractice"]
      end

      on :message, /.+/ do |m|
        Message.create!(:body => m.message, :author => m.user.nick)
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