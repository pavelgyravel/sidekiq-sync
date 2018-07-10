$stdout.sync = true

require "sidekiq"
require_relative "e2e_worker"

require "kommando"
$sidekiq_runner = Kommando.new "sidekiq -r./e2e/e2e_worker.rb", {
  output: true
}
$sidekiq_runner.run_async

smoke_value = E2EWorker.perform_sync "smoke"
raise "smoke" unless smoke_value == "smoke"

got_exception = false
begin
  E2EWorker.perform_sync "nothing", 2, Sidekiq::Sync::Options.new(timeout: 1)
rescue Sidekiq::Sync::TimeoutError
  got_exception = true
end
raise "raise" unless got_exception

timeout_value = E2EWorker.perform_sync "timeout_and_raise_false", 2, Sidekiq::Sync::Options.new(timeout: 1, raise: false)
raise "timeout_and_raise_false" if timeout_value

puts "OK"
$sidekiq_runner.kill
