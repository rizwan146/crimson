# frozen_string_literal: true

require 'websocket-eventmachine-server'

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
      @socket.send(message)
    end

    def on_open(*args)
      puts "Client #{id} connected."
    end

    def on_message(msg, _type)
      puts "Client #{id} Received message: #{msg}."
    end

    def on_close(*args)
      puts "Client #{id} disconnected."
    end
  end
end
