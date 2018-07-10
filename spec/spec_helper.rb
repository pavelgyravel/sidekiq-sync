require "bundler/setup"
require "sidekiq/sync"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:suite) do
    unless ENV["GUARD_ACTIVE"]
      $sidekiq_runner.kill
    end

    Sidekiq.redis do |r|
      r.flushall
    end
  end
end

require_relative "workers/hard_worker"

unless ENV["GUARD_ACTIVE"]
  require "kommando"
  $sidekiq_runner = Kommando.new "sidekiq -r./spec/workers/hard_worker.rb", {
    output: true
  }
  $sidekiq_runner.run_async
end


