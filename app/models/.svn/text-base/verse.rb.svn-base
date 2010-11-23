class Verse < ActiveRecord::Base
  belongs_to :book
  
  acts_as_ferret :fields => ['book_id', 'chapter_id', 'number', 'content'],
    :remote => true,
    :store_class_name => true,
    :analyzer => Ferret::Analysis::StandardAnalyzer.new([]) # No stop words
    
  acts_as_solr :fields => ['book_id', 'chapter_id', 'number', 'content']
    
  is_indexed :fields => ['book_id', 'chapter_id', 'number', 'content']
  
end
