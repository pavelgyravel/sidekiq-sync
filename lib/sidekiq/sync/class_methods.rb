module Sidekiq
  module Sync
    module ClassMethods
      def perform_sync(*args)
        real_args = []
        options = Sidekiq::Sync::Options.new
        for arg in args
          if arg.is_a? Sidekiq::Sync::Options
            options = arg
          else
            real_args << arg
          end
        end

        return_channel = "sidekiq-sync:#{SecureRandom::uuid}"

        self.perform_async(return_channel, *real_args)
#        queue_or_nil_if_timeout, value = Sidekiq::Sync.redis.blpop return_channel, timeout: options.timeout
        queue_or_nil_if_timeout, value = Sidekiq.redis do |r|
          r.blpop return_channel, timeout: options.timeout
        end

        unless queue_or_nil_if_timeout
          raise Sidekiq::Sync::TimeoutError if options.raise
        end

        value
      end
    end
  end
end
