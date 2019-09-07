# frozen_string_literal: true

require_relative 'base'

module Crimson
  class Creator
    def initiallize; end

    def create(object, clients = app.clients)
      raise TypeError unless object.is_a?(Crimson::Object)

      app.objects[object.id] = object

      return if clients.empty?

      message = object.to_msg.merge(
        action: 'create'
      ).to_json

      clients.each { |client| client.send(message) }
    end

    def app
      Crimson::Application.instance
    end
  end
end
