require "rspec"
require "pry"
require "tempfile"
require "sliding_puzzle"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.color = true
  config.formatter = :doc
end
