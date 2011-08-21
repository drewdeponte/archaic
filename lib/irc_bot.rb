require 'cinch'
require 'date'
require 'open-uri'

module IrcBot
  def self.run
    bot = Cinch::Bot.new do
      configure do |c|
        c.nick = Archaic::CONFIG.irc_nick
        c.server = Archaic::CONFIG.irc_server
        c.channels = Archaic::CONFIG.irc_channels       
      end

      on :message, /.+/ do |m|
        Message.create(:body => m.message, :author => m.user.nick)
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

    on :message, /scenestar/ do |m|
      num = 5
      shows = []
      doc = Nokogiri::HTML(open('http://thescenestar.typepad.com/shows/'))
      doc.css("#showsList tr").each do |tr|
        date = tr.at_css('div[align=left]')
        link = tr.at_css('a')
        if date && link
          begin 
            date = Date.strptime(date.text, "%m.%d.%y")
            shows << {:title => link.parent.text, :url => link.attribute("href").text, :date => date}
          rescue Exception => e
            next
           end
        end
      end

      shows = shows.sort {|x,y| x[:date] <=> y[:date] }[0, num.to_i]
      m.reply "#{m.user.nick} the next 5 shows are:"
      shows.each do |s|
        m.reply s[:date].to_s + ": " + s[:title] + " - " + s[:url] 
      end
    end

    on :message, /quotegrab grab (.+)/ do |m, user|
      grabbed = Message.where(:author => user).last
      (m.reply "#{m.user.nick}: No messages for #{user}" and return) unless grabbed
      Quote.create! do |g|
        g.grabber_nick = m.user.nick
        g.grabbed_nick = user
        g.message_id   = grabbed.id
      end
      m.reply "#{m.user.nick}: Forcegrab!!!."
    end

    on :message, /quotegrab list (.+)?/ do |m, user|
      mygrabs = Quote.where(:grabber_nick => m.user.nick).all
      (m.reply "#{m.user.nick}: You have no quotes." and return) unless mygrabs.any?
      mygrabs = mygrabs.select{|g| g.grabbed_nick == user} if user
      (m.reply "#{m.user.nick}: You have no quotes for #{user}." and return) unless mygrabs.any?
      mygrabs.each_with_index do|g, idx|
        m.reply "#{m.user.nick}: [#{idx}] #{g.message.body}"
      end
    end

    on :message, /quotegrab fetch (.+) (.+)/ do |m, user, idx|
      theirgrabs = Quote.where(["grabbed_nick = ?", user]).all
      (m.reply "#{m.user.nick}: No quotes found for #{user}." and return) unless theirgrabs.any?
      fetched    = nil
      if idx =~ /random/i
        srand
        fetched = theirgrabs[rand((theirgrabs.length) -1)]
      elsif idx =~ /\d+/
        fetched = theirgrabs[idx.to_i]
      else
        (m.reply "#{m.user.nick}: Can't find a quote that that index.")
      end
      m.reply "#{m.user.nick} #{fetched.message.body}"
    end

    on :message, /quotegrab delete (\d+) (.+)?/ do |m, idx, user|
      mygrabs = Quote.where(:grabber_nick => m.user.nick).all
      mygrabs = mygrabs.select{|g| g.grabbed_nick == user} if user
      (m.reply "#{m.user.nick}: Quote was deleted.") if mygrabs[idx].destroy!
    end

  end

  bot.start
end
end

IrcBot::run
