require 'eventmachine'

module Crimson
  module Publisher
    def is_subscriber?(subscriber)
      subscribers.key?(subscriber.id)
    end

    def add_subscriber(subscriber, on_publish)
      return if is_subscriber?(subscriber)

      subscribers[subscriber.id] = channel.subscribe(&subscriber.method(on_publish))
    end

    def remove_subscriber(subscriber)
      return unless is_subscriber?(subscriber)

      channel.unsubscribe(subscribers[subscriber.id])
      subscribers.delete(subscriber.id)
    end
  end
end