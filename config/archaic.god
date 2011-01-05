RAILS_ROOT = File.dirname(File.dirname(__FILE__))

God.watch do |w|
  irc_serv = "#{RAILS_ROOT}/script/archaic_ircbot_service"
  
  w.name = "archaic-irc-bot"
  w.group = "archaic"
  w.interval = 60.seconds
  w.start = "#{irc_serv} start"
  w.restart = "#{irc_serv} restart"
  w.stop = "#{irc_serv} stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/archaic_ircbot_service.pid"
  
  w.behavior(:clean_pid_file)
  
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end
    
    restart.condition(:cpu_usage) do |c|
      c.above = 80.percent
      c.times = 5
    end
  end
  
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minutes
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end