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
      puts "Client #{id} Sending message: #{message}."
      @socket.send(message)
    end

    def on_open(*args)
      puts "Client #{id} connected."
      app.add_client(self)
      app.creater.create(app.root, clients: [self])
    end

    def on_message(msg, _type)
      puts "Client #{id} Received message: #{msg}."
    end

    def on_close(*args)
      puts "Client #{id} disconnected."
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
