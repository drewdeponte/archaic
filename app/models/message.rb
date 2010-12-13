class Message < ActiveRecord::Base
  def self.upper_context(m, num_msgs = 5)
    start_id = m.id - num_msgs
    if (start_id < 0)
      start_id = 0
    end
    find_by_sql(["select t.* from messages t where t.id > #{start_id} and t.id < #{m.id} order by t.created_at desc limit #{num_msgs}"])
  end
  
  def self.lower_context(m, num_msgs = 5)
    end_id = m.id + num_msgs
    find_by_sql(["select t.* from messages t where t.id > #{m.id} and t.id < #{end_id} order by t.created_at desc limit #{num_msgs}"])
  end
  
  def self.search(terms)
    find_by_sql(["select t.* from messages t where #{ (["(lower(t.body) like ? or lower(t.author) like ?)"] * terms.size).join(" or ") } order by t.created_at desc", *(terms * 2).sort])
  end
end
