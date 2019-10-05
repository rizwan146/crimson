require 'eventmachine'

module Crimson
  module Publisher
    def is_subscriber?(subscriber)
      subscribers.key?(subscriber)
    end

    def add_subscriber(subscriber, on_publish)
      return if is_subscriber?(subscriber)

      subscribers[subscriber] = channel.subscribe(&subscriber.method(on_publish))
    end

    def remove_subscriber(subscriber)
      return unless is_subscriber?(subscriber)

      channel.unsubscribe(subscribers[subscriber])
      subscribers.delete(subscriber)
    end

    def each_subscriber
      subscribers.each_key{ |subscriber| yield subscriber }
    end

    def emit(*args)
      channel << [self, *args]
    end
  end
end