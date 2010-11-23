
require "#{RAILS_ROOT}/config/environment"
require "benchmark"
require "echoe"

TIMES = 300

namespace :benchmark do
  task :sphinx do
    puts "\nSphinx"

    Echoe.silence do
      system("killall searchd")
      system("rm -rf /tmp/benchmark")
      system("rake us:boot")
    end
    counts = []
    
    Benchmark.bm(20) do |x|
      x.report "reindex" do
        # Call indexer directly in order to avoid the overhead of starting Ruby, since the other indexers execute
        # in the current Ruby process even though they would have their own startup overhead in a production
        # script.
        Echoe.silence { system("indexer --config '#{RAILS_ROOT}/config/ultrasphinx/development.conf' --rotate --all") }
      end if ENV['INDEX'] 
      
      counts << Ultrasphinx::Search.new(:class_names => 'Verse', :query => "God", :per_page => 10, :page => 3).total_entries
      x.report "verse:god" do
        TIMES.times { Ultrasphinx::Search.new(:class_names => 'Verse', :query => "God", :per_page => 10, :page => 3).run }
      end
      x.report "verse:god:no_ar" do
        TIMES.times { Ultrasphinx::Search.new(:class_names => 'Verse', :query => "God", :per_page => 10, :page => 3).run(false) }
      end

      counts << Ultrasphinx::Search.new(:class_names => 'Book', :query => "God", :per_page => 10).total_entries
      x.report "book:god" do
        TIMES.times { Ultrasphinx::Search.new(:class_names => 'Book', :query => "God", :per_page => 10).run }
      end

      counts << Ultrasphinx::Search.new(:query => "God", :per_page => 10, :page => 3).total_entries
      x.report "all:god" do
        TIMES.times { Ultrasphinx::Search.new(:query => "God", :per_page => 10, :page => 3).run }
      end
      
      counts << Ultrasphinx::Search.new(:query => "molten calves", :per_page => 10).total_entries
      x.report "all:calves" do
        TIMES.times { Ultrasphinx::Search.new(:query => "molten calves", :per_page => 10).run }
      end

      counts << Ultrasphinx::Search.new(:query => "Moreover he said unto me, Son of man, eat that thou findest", :per_page => 10).total_entries
      x.report "all:moreover" do
        TIMES.times { Ultrasphinx::Search.new(:query => "Moreover he said unto me, Son of man, eat that thou findest", :per_page => 10).run }
      end

    end
    
    puts "result counts: #{counts.inspect}"
    puts "index size: #{`du -ch /tmp/benchmark | grep total`}"
    memory("/tmp/benchmark/log/searchd.pid")    
  end
  
  task :ferret do
    puts "\nFerret"
    
    Echoe.silence do
      system("script/ferret_server stop")
      system("rm -rf #{RAILS_ROOT}/index/development")
      system("script/ferret_server start")
    end
    counts = []
    
    Benchmark.bm(20) do |x|      
      x.report "reindex" do
        Verse.rebuild_index
        Book.rebuild_index
      end if ENV['INDEX']
      
      counts << Verse.find_by_contents("God", :limit => 10, :offset => 20).total_hits
      x.report "verse:god" do
        TIMES.times { Verse.find_by_contents("God", :limit => 10, :offset => 20) }
      end

      counts << Book.find_by_contents("God", :limit => 10).total_hits
      x.report "book:god" do
        TIMES.times { Book.find_by_contents("God", :limit => 10) }
      end

      counts << Verse.find_by_contents("God", :multi => [Book], :limit => 10, :offset => 20).total_hits
      x.report "all:god" do
        TIMES.times { Verse.find_by_contents("God", :multi => [Book], :limit => 10, :offset => 20) }
      end
      
      counts << Verse.find_by_contents("molten calves", :multi => [Book], :limit => 10).total_hits
      x.report "all:calves" do
        TIMES.times { Verse.find_by_contents("molten calves", :multi => [Book], :limit => 10) }
      end

      counts << Verse.find_by_contents("Moreover he said unto me, Son of man, eat that thou findest", :multi => [Book], :limit => 10).total_hits      
      x.report "all:moreover" do
        TIMES.times { Verse.find_by_contents("Moreover he said unto me, Son of man, eat that thou findest", :multi => [Book], :limit => 10) }
      end

    end
    
    puts "result counts: #{counts.inspect}"
    puts "index size: #{`du -ch #{RAILS_ROOT}/index/ | grep total`}" 
    memory("#{RAILS_ROOT}/log/ferret.pid")
  end
  
  task :solr do
    puts "\nSolr"
    
    Echoe.silence do
      system("rake solr:stop")
      system("rake solr:start")
    end 
    counts = []
    
    Benchmark.bm(20) do |x|
      x.report "reindex" do
        Verse.rebuild_solr_index(4000)
        Book.rebuild_solr_index(4000)
      end if ENV['INDEX']
      
      counts << Verse.find_by_solr("God", :limit => 10, :offset => 20).total_hits
      x.report "verse:god" do
        TIMES.times { Verse.find_by_solr("God", :limit => 10, :offset => 20) }
      end

      counts << Book.find_by_solr("God", :limit => 10).total_hits
      x.report "book:god" do
        TIMES.times { Book.find_by_solr("God", :limit => 10) }
      end

      counts << Verse.multi_solr_search("God", :models => [Book], :limit => 10, :offset => 20).total_hits
      x.report "all:god" do
        TIMES.times { Verse.multi_solr_search("God", :models => [Book], :limit => 10, :offset => 20) }
      end
      
      counts << Verse.multi_solr_search("molten calves", :models => [Book], :limit => 10).total_hits
      x.report "all:calves" do
        TIMES.times { Verse.multi_solr_search("molten calves", :models => [Book], :limit => 10) }
      end

      counts << Verse.multi_solr_search("Moreover he said unto me, Son of man, eat that thou findest", :models => [Book], :limit => 10).total_hits      
      x.report "all:moreover" do
        TIMES.times { Verse.multi_solr_search("Moreover he said unto me, Son of man, eat that thou findest", :models => [Book], :limit => 10) }
      end

    end
    
    puts "result counts: #{counts.inspect}"
    puts "index size: #{`du -ch #{RAILS_ROOT}/vendor/plugins/acts_as_solr/solr/solr/data/development/index | grep total`}"        
    memory("#{RAILS_ROOT}/vendor/plugins/acts_as_solr/solr/tmp/development_pid")
  end
end

task :benchmark => ['benchmark:sphinx', 'benchmark:solr', 'benchmark:ferret'] do
end

def memory(pidfile)
  pid = File.open(pidfile) {|f| f.readlines.first.chomp }
  a = `ps -o vsz,rss -p #{pid}`.split(/\s+/)[-2..-1].map{|el| el.to_i}
  puts "daemon memory usage in kb: #{ {:virtual => a.first - a.last, :total => a.first, :real => a.last}.inspect }"
end
