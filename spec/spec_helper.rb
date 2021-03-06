require 'rubygems'
require 'bundler/setup'
require 'rspec/autorun'
require "test_notifier/runner/rspec"
require File.expand_path '../../lib/boleto_br', __FILE__

TestNotifier.default_notifier = :growl

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
