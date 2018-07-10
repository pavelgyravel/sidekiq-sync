require "redis"

require_relative "sync/version"
require_relative "sync/worker"
require_relative "sync/class_methods"
require_relative "sync/performer"
require_relative "sync/timeout_error"
require_relative "sync/options"

module Sidekiq
  module Sync
  end
end
