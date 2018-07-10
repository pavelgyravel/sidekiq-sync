require "sidekiq"

module Sidekiq
  module Sync
    module Worker
      def self.included(includer)
        includer.include Sidekiq::Worker
        includer.prepend Sidekiq::Sync::Performer
        includer.extend Sidekiq::Sync::ClassMethods
      end
    end
  end
end
