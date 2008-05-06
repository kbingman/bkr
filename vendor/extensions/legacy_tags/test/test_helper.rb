ENV["RAILS_ENV"] = "test"

require "../../../config/environment"
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end