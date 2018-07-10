# sidekiq-sync

Adds `perform_sync` to Sidekiq to get the return value from perform while still executing through Sidekiq (distributed workers!). Internally it stores the result in a unique queue that is polled.

## install

```
gem install 'sidekiq-sync'
```

## usage

```
class HardWorker
  include Sidekiq::Sync::Worker

  def perform(how_hard="super hard", how_long=1)
    puts "working #{how_hard}"
    sleep how_long
    "I worked #{how_hard}"
  end
end

puts HardWorker.perform_sync("really hard")
# outputs "I worked really hard"

puts HardWorker.perform_async("really hard")
# outputs the sidekiq job..

options = Sidekiq::Sync::Options.new(timeout: 3)
puts HardWorker.perform_sync(options, "really hard", 4)
# times out in 3 seconds and raises Sidekiq::Sync::TimeoutError

options = Sidekiq::Sync::Options.new(timeout: 3, raise: false)
puts HardWorker.perform_sync(options, "really hard", 4)
# times out in 3 seconds, returns nil, does not raise

options = Sidekiq::Sync::Options.new(timeout: 3, raise: false)
puts HardWorker.perform_sync(options, "really hard", 4)
# times out in 3 seconds, returns nil, does not raise

options = Sidekiq::Sync::Options.new(timeout: 3, raise: false)
puts HardWorker.perform_sync("really hard", options, 4)
# options can be wherever you wish (still sleeps 4, timeouts in 3 and does not raise)
```
