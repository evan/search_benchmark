class Book < ActiveRecord::Base
  has_many :verses
  
  acts_as_ferret :fields => ['name', 'content'],
    :remote => true,
    :store_class_name => true,
    :analyzer => Ferret::Analysis::StandardAnalyzer.new([]) # No stop words    

  acts_as_solr :fields => ['name', 'content']
  
  is_indexed :fields => ['name'],
    :concatenate => [{:association_name => 'verses', :field => 'content', :as => 'content'}]
  
  def content
    verses.map(&:content).join(" ")
  end
  
end
