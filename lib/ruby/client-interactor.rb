# frozen_string_literal: true

require 'websocket-eventmachine-server'
require_relative 'base'

module Crimson
  class ClientInteractor
    attr_reader :id

    @@id_count = 1

    def initialize(socket)
      @id = @@id_count
      @@id_count += 1

      @socket = socket
      @socket.onopen(&method(:on_open))
      @socket.onmessage(&method(:on_message))
      @socket.onclose(&method(:on_close))
    end

    def send(message)
      app.logger.debug "[ClientInteractor] Sending to #{id}, message: #{message}."
      @socket.send(message)
    end

    def on_open(*args)
      app.logger.debug "[ClientInteractor] #{id} connected."
      app.add_client(self)
      app.creator.create(app.root, clients: [self])
    end

    def on_message(msg, _type)
      app.logger.debug "[ClientInteractor] Received from #{id}, message: #{msg}."
      msg = JSON.parse(msg)
      case msg["action"]
      when 'notify' then app.notifier.notify(msg)
      end
    end

    def on_close(*args)
      app.logger.debug "[ClientInteractor] #{id} disconnected."
      app.remove_client(self)
    end

    def ==(client)
      raise TypeError unless client.is_a?(ClientInteractor)
      self.id == client.id
    end

    def app
      Crimson::Application.instance
    end
  end
end
