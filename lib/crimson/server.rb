# frozen_string_literal: true

require 'async/websocket/adapters/rack'
require_relative 'client'
require_relative 'utilities'

module Crimson
  class Server
    attr_reader :clients

    def initialize
      @clients = {}
    end

    def on_connect(&block)
      @on_connect = block if block_given?
    end

    def on_disconnect(&block)
      @on_disconnect = block if block_given?
    end

    def self.template_html_path
      File.expand_path("#{__dir__}/../html/template.html")
    end

    def self.static
      { :urls => [File.expand_path("#{__dir__}/.."), File.expand_path("#{__dir__}/../javascript")] }
    end

    def content(port, path = Server.template_html_path)
      template = File.read(path)
      template.sub!("{PORT}", port)

      [template]
    end

    def call(env)
      call_async(env) or call_faye(env) or serve_template(env)
    end

    def call_async(env)
      Async::WebSocket::Adapters::Rack.open(env, protocols: ['ws']) do |connection|
        id = :"client_#{Utilities.generate_id}"
        client = Client.new(id, connection)
        clients[connection] = client
        
        @on_connect&.call(client)

        begin
          while message = connection.read
            client.on_message(message)
          end
        rescue Protocol::WebSocket::ClosedError
          
        end
      ensure
        @on_disconnect&.call(client)
        clients.delete(connection)
        connection.close
      end
    end

    def call_faye(env)
      if Faye::WebSocket.websocket?(env)
        connection = Adapters::Faye.new(env)
        id = :"client_#{Utilities.generate_id}"
        client = Client.new(id, connection)
        clients[id] = client

        @on_connect&.call(client)

        connection.on :message do |event|
          client.on_message(event.data)
        end
    
        connection.on :close do |event|
          @on_disconnect&.call(client)
          clients.delete(id)
          connection = nil
        end

        connection.rack_response
      end
    end

    def serve_template(env)
      if env['REQUEST_PATH'] != '/'
        return Rack::Directory.new(File.expand_path("#{__dir__}/..")).call(env)
      else
        return [200, {"Content-Type" => "text/html"}, content(env['SERVER_PORT'])]
      end
    end
  end
end
