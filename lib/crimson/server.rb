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
      { :urls => [""], :root => File.expand_path("#{__dir__}/.."), :index => 'html/template.html' }
    end

    def content(port, path = Server.template_html_path)
      template = File.read(path)
      template.sub!("{PORT}", port)

      [template]
    end

    def call(env)
      Async::WebSocket::Adapters::Rack.open(env, protocols: ['ws']) do |connection|
        id = :"client_#{Utilities.generate_id}"
        client = Client.new(id, connection)
        clients[connection] = client
        
        @on_connect&.call(client)
        client.listen
      ensure
        @on_disconnect&.call(client)
        clients.delete(connection)
      end or [200, {}, [""]]
    end
  end
end
