# frozen_string_literal: true

require 'websocket-eventmachine-server'
require 'singleton'
require_relative 'creator'
require_relative 'updater'
require_relative 'destroyer'
require_relative 'object'
require_relative 'notifier'
require_relative 'client-interactor'

module Crimson
  class Application
    include Singleton
    attr_accessor :name, :host, :port
    attr_reader :clients, :objects, :creator, :updater, :destroyer, :notifier

    def initialize(name: 'myapp', host: '0.0.0.0', port: 10_000)
      @name = name
      @host = host
      @port = port

      @creator = Crimson::Creator.new
      @updater = Crimson::Updater.new
      @destroyer = Crimson::Destroyer.new
      @notifier = Crimson::Notifier.new

      @clients = []
      @objects = {}
      @root = nil
    end

    def add_client(client)
      raise TypeError unless client.is_a?(ClientInteractor)
      @clients << client unless @clients.include?(client)
    end

    def remove_client(client)
      raise TypeError unless client.is_a?(ClientInteractor)
      @clients.delete(client)
    end

    def root
      @root = Widget.new(parent: nil) if @root.nil?
      @root
    end

    def run
      EM.run do
        start
      end
    end

    def start
      WebSocket::EventMachine::Server
        .start(host: @host, port: @port) { |ws| Crimson::ClientInteractor.new(ws) }
    end
  end
end
