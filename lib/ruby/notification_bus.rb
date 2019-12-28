
require 'hashie'
require_relative 'object'

module Crimson
  class NotificationBus
    attr_reader :notification_handlers

    def initialize
      @notification_handlers = Hashie::Mash.new
    end

    def register(object)
      raise ArgumentError unless object.is_a?(Crimson::Object)
      raise ArgumentError if notification_handlers.key?(object.id)

      notification_handlers[object.id] = object.method(:on_event)
    end

    def unregister(object)
      raise ArgumentError unless object.is_a?(Crimson::Object)
      raise ArgumentError unless notification_handlers.key?(object.id)

      notification_handlers.delete(object.id)
    end

    def notify(message)
      raise ArgumentError unless notification_handlers.key?(message.id)

      notification_handlers[message.id].call(message)
    end
  end
end