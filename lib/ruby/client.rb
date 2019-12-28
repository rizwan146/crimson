# frozen_string_literal: true

require 'hashie'
require_relative 'notification_bus'

module Crimson
  class Client
    attr_reader :id, :connection, :notification_bus

    def initialize(id, connection)
      @id = id

      @connection = connection
      @connection.onmessage(&method(:on_message))

      @notification_bus = NotificationBus.new
    end

    def on_message(message, type)
      message = Hashie::Mash.new(JSON.parse(message))
      
      case message.action
      when "event"
        notification_bus.notify(message)
      end
    end

    def write(message = {})
      connection.send(message.to_json)
    end

    def on_commit(object, changes)
      write(
        action: :update,
        id: object.id,
        changes: changes
      )
    end

    def observe(object)
      object.node.postordered_each do |sub_node|
        observable = sub_node.content

        write(
          action: :create,
          id: observable.id,
          tag: observable.tag,
          changes: observable.master
        )

        observable.add_observer(self)
        notification_bus.register(observable)
      end
    end

    def unobserve(object)
      object.node.postordered_each do |sub_node|
        observable = sub_node.content

        observable.remove_observer(self)
        notification_bus.unregister(observable)

        write(
          action: :destroy,
          id: observable.id
        )
      end
    end

    def observing?(object)
      object.observers.key?(self)
    end

    def ==(other)
      other.is_a?(Client) && other.id == id
    end

    def eql?(other)
      self == other
    end

    def hash
      id.hash
    end
  end
end
