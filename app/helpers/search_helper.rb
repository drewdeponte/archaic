module SearchHelper
  def mark_terms(str, terms)
    if str.nil?
      return str
    end
    rv = str
    terms.each { |t|
      rv = rv.gsub(/#{t}/i, "<span class=\"search_term\">\\0</span>")
    }
    return rv
  end
end
