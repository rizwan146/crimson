require 'eventmachine'

module Crimson
  module Publisher
    def is_subscriber?(subscriber)
      subscribers.key?(subscriber.id)
    end

    def link(other_publisher, on_self, on_other)
      self.add_subscriber(other_publisher, on_self)
      other_publisher.add_subscriber(self, on_other)
    end

    def unlink(other_publisher)
      other_publisher.remove_subscriber(self)
      self.remove_subscriber(other_publisher)
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