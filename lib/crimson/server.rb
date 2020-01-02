# frozen_string_literal: true

require 'thin'
require 'websocket-eventmachine-server'
require_relative 'client'
require_relative 'webserver'
require_relative 'utilities'

module Crimson
  class Server
    attr_reader :clients

    def initialize(opts = {})
      @opts = opts || {}
      @clients = {}
    end

    def host
      @opts[:host] || '0.0.0.0'
    end

    def on_connect(&block)
      @on_connect = block if block_given?
    end

    def on_disconnect(&block)
      @on_disconnect = block if block_given?
    end

    def port
      @opts[:port] || 10_000
    end

    def run(websocket_enabled: true, webserver_enabled: true)
      EM.run do
        start_websocket if websocket_enabled
        start_webserver if webserver_enabled
      end
    end

    def start_webserver
      template = File.read("#{__dir__}/../html/template.html")
      template.sub!("{PORT}", websocket_port.to_s)

      Thin::Server.start(WebServer.new(template), host, port, signals: false)
    end

    def start_websocket
      WebSocket::EventMachine::Server.start(host: host, port: websocket_port) do |ws|
        id = :"client_#{Utilities.generate_id}"
        client = Client.new(id, ws)

        ws.onopen {
          clients[id] = client
          @on_connect.call(client)
        }

        ws.onclose {
          @on_disconnect.call(client)
          clients.delete(id)
        }
      end
    end

    def websocket_port
      port + 1
    end
  end
end
