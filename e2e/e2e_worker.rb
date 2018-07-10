require_relative "../lib/sidekiq/sync"

class E2EWorker
  include Sidekiq::Sync::Worker

  def perform(what, how_long=0)
    puts "performing: #{what}"
    sleep how_long
    what
  end
end
