require 'json'
require_relative 'base'

module Crimson
  class Updater
    def initialize

    end

    def update(id, args = {}, clients = app.clients)
      message = args.merge(
        id: id,
        action: 'update'
      ).to_json

      clients.each { |client| client.send(message) }
    end

    def app
      Crimson::Application.instance
    end
  end
end