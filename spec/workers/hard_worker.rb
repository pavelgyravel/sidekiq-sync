require_relative "../../lib/sidekiq/sync"

class HardWorker
  include Sidekiq::Sync::Worker

  def perform(how_hard="super hard", how_long=1)
    sleep how_long
    return how_hard
  end
end
