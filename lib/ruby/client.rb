# frozen_string_literal: true

module Crimson
  class Client
    attr_reader :id, :connection

    def initialize(id, connection)
      @id = id

      @connection = connection
      @connection.onmessage(&method(:on_message))
    end

    def on_message(message, type); end

    def write(message = {})
      connection.send(message.to_json)
    end

    def on_commit(object)
      write(
        action: :update,
        id: object.id,
        changes: object.new_changes
      )
    end

    def observe(object)
      write(
        action: :create,
        id: object.id,
        tag: object.tag,
        changes: object.master
      )

      object.add_observer(self)
    end

    def unobserve(object)
      object.remove_observe(self)

      write(
        action: :destroy,
        id: object.id
      )
    end

    def observing?(object)
      object.observers.key?(self)
    end

    def ==(other)
      other.is_a?(Client) && other.id == id
    end
  end
end
