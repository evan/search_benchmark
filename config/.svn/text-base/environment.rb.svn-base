
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

# XXX Um ok
require 'action_controller'
require 'vendor/plugins/acts_as_ferret/lib/class_methods' 
require 'vendor/plugins/acts_as_ferret/lib/ferret_result'
require 'vendor/plugins/acts_as_ferret/lib/search_results'
require 'vendor/plugins/acts_as_ferret/lib/instance_methods'

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_benchmark_session',
    :secret      => 'a237ec9ba55e60834560289e8cd047bec4d25aeccc0861108690a43d4307a627dd965f762452ada5e1c245d317b0bc57ffab81c26186feed56c3761af89b5620'
  }

end

require 'ruby-debug' if ENV['DEBUG']
