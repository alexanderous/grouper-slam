#redis solution -- doesn't quite work -- adds way too many suggestions, lowercase and uppercase, and then it goes below the footer. weird

#class SearchSuggestion
#  def self.terms_for(prefix)
#    $redis.zrevrange "search-suggestions:#{prefix.downcase}", 0, 9
#  end
  
#  def self.index_users
#    User.find_each do |user|
#      index_term(user.name)
#      #index_term(user.category)
#      user.name.split.each { |t| index_term(t) }
#    end
#  end
  
#  def self.index_term(term)
#    1.upto(term.length-1) do |n|
#      prefix = term[0, n]
#      $redis.zincrby "search-suggestions:#{prefix.downcase}", 1, term
#    end
#  end
#end

#class SearchSuggestion < ActiveRecord::Base
#  attr_accessible :popularity, :term
  
#  def self.terms_for(prefix)
#    Rails.cache.fetch(["search-terms", prefix]) do
#      suggestions = where("term like ?", "#{prefix}_%")
#      suggestions.order("popularity desc").limit(10).pluck(:term)
#    end
#  end
  
#  def self.index_users
#    User.find_each do |user|
#      index_term(user.name)
#      #index_term(user.category)
#      user.name.split.each { |t| index_term(t) }
#    end
#  end
  
#  def self.index_term(term)
#    where(term: term.downcase).first_or_initialize.tap do |suggestion|
#      suggestion.increment! :popularity
#    end
#  end
#end