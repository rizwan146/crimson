# frozen_string_literal: true

require_relative 'element_manager'

module Crimson
  class Client
    include ElementManager

    attr_reader :connection

    def initialize(connection)
      @connection = connection
      @connection.onmessage(&method(:on_message))
    end

    def on_message(message, type)

    end

    def write(message)
      connection.send(message)
    end

    def on_commit(changes)
      super
    end

    def observe(element)
      write(element.master.merge(action: :create))
      element.add_observer(self)
    end

    def unobserve(element)
      element.remove_observer(self)
      write(element.minimal.merge(action: :destroy))
    end
  end
end
