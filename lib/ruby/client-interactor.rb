# frozen_string_literal: true

module Crimson
  class ClientInteractor
    def initiaiize(socket)
      @socket = socket

      @socket.onopen(&method(:on_open))
      @socket.onmessage(&method(:on_message))
      @socket.onclose(&method(:on_close))
    end

    def send(message)
      @socket.send(message)
    end

    def on_open
      puts 'Client connected'
    end

    def on_message(msg, _type)
      puts "Received message: #{msg}"
    end

    def on_close
      puts 'Client disconnected'
    end
  end
end
