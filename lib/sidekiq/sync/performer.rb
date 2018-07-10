module Sidekiq
  module Sync
    module Performer
      def perform(*args)
        if args[0] && args[0].start_with?("sidekiq-sync:")
          channel = args.shift
          result = super(*args)

          Sidekiq.redis do |r|
            r.lpush channel, result
            r.expire channel, 1
          end

          result
        else
          super(*args)
        end
      end
    end
  end
end
