require "bundler/setup"
require "active_record"
require "pry-byebug"

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

require "kushojin"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
# ActiveRecord::Base.logger = ::Logger.new(STDOUT)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string  :name
    t.integer :age

    t.timestamps
  end
end

class User < ActiveRecord::Base
  record_changes
end
