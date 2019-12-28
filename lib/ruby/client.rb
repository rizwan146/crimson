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
      object.node.postordered_each do |sub_node|
        observable = sub_node.content

        write(
          action: :create,
          id: observable.id,
          tag: observable.tag,
          changes: observable.master
        )

        observable.add_observer(self)
      end
    end

    def unobserve(object)
      object.node.postordered_each do |sub_node|
        observable = sub_node.content

        observable.remove_observer(self)

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
