require_relative "../../lib/sidekiq/sync"

class HardWorker
  include Sidekiq::Sync::Worker

  def perform(how_hard="super hard", how_long=1)
    if how_hard == "async"
      Sidekiq.redis do |r|
        r.set "didasync", true
      end
    else
      sleep how_long
      return how_hard
    end
  end
end
