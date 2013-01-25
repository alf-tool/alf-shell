$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf-shell'
require "rspec"

module Helpers

end

RSpec.configure do |c|
  c.include Helpers
  c.extend  Helpers
  c.filter_run_excluding :ruby19 => (RUBY_VERSION < "1.9")
end