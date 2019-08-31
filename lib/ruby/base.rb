# frozen_string_literal: true

require 'json'
require 'websocket-eventmachine-server'
require_relative 'client-interactor'

module Crimson
  class Application
    attr_accessor :host, :port
    attr_reader :clients, :objects

    def initialize(host: "0.0.0.0", port: 10000)
      @host = host
      @port = port
      @clients = []
      @objects = {}
    end

    def run
      EM.run do
        start_server
      end
    end

    def start_server
      WebSocket::EventMachine::Server
        .start(host: @host, port: @port) { |ws|
          client = Crimson::ClientInteractor.new(ws)
        }
    end
  end
end
