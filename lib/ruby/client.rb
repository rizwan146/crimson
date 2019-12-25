# frozen_string_literal: true

module Crimson
  class Client
    attr_reader :id, :connection

    def initialize(id, connection)
      @id = id

      @connection = connection
      @connection.onmessage(&method(:on_message))
    end

    def on_message(message, type)

    end

    def write(message)
      connection.send(message)
    end

    def on_commit(changes)
    end

    def observe(element)
    end

    def unobserve(element)
    end
  end
end
