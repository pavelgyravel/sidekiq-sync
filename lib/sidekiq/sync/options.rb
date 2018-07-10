module Sidekiq
  module Sync
    class Options
      attr_reader :timeout, :raise
      def initialize(opts={})
        @timeout = opts[:timeout] || 0
        @raise = if opts[:raise] == false
          false
        else
          true
        end
      end
    end
  end
end
