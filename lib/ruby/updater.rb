require 'json'
require_relative 'base'

module Crimson
  class Updater
    def initialize

    end

    def update(id, args = {})
      message = args.merge(
        id: id,
        action: 'update'
      ).to_json

      app.clients.each { |client| client.send(message) }
    end

    def app
      Crimson::Application.instance
    end
  end
end