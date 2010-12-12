class Message < ActiveRecord::Base
  def self.search(terms)
    find_by_sql(["select t.* from messages t where #{ (["(lower(t.body) like ? or lower(t.author) like ?)"] * terms.size).join(" or ") } order by t.created_at desc", *(terms * 2).sort])
  end
end
