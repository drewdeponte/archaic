class SearchController < ApplicationController
  def search
    @search_res = []
    @search_terms = []
    @performed_search = false
    if params.has_key?(:search_terms) && !params[:search_terms].empty?
      @performed_search = true
      @search_terms = params[:search_terms].split
      @search_res = Message.search(@search_terms.collect{ |c| "%#{c.downcase}%" })
    end
  end
end