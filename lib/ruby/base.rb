# frozen_string_literal: true

require 'websocket-eventmachine-server'
require 'singleton'
require 'sinatra'
require 'thin'

require_relative 'creator'
require_relative 'updater'
require_relative 'destroyer'
require_relative 'object'
require_relative 'notifier'
require_relative 'client-interactor'
require_relative 'webserver'
require_relative 'webview'

module Crimson
  class Application
    include Singleton
    attr_accessor :name, :webserver_host, :webserver_port, :websocket_host, :websocket_port
    attr_accessor :width, :height, :resizable
    attr_reader :clients, :objects, :creator, :updater, :destroyer, :notifier
    attr_reader :webview

    def initialize(
        name: 'myapp',
        webserver_host: '0.0.0.0',
        webserver_port: 9_000,
        websocket_host: '0.0.0.0',
        websocket_port: 10_000,
        width: 800,
        height: 600
      )
      
      @name = name
      
      @webserver_host = webserver_host
      @webserver_port = webserver_port
      
      @websocket_host = websocket_host
      @websocket_port = websocket_port

      @width = width
      @height = height
      @resizable = resizable

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

    def run(websocket_enabled: true, webserver_enabled: true, webview_enabled: true)
      EM.run do
        start_websocket if websocket_enabled
        start_webserver if webserver_enabled
        start_webview if webview_enabled
      end
    end

    def start_webview
      @webview = Crimson::WebView.new()
      @webview.qt.setWindowTitle(name)
      @webview.qt.resize(width, height)
      @webview.load("http://#{webserver_host}:#{webserver_port}")
      @webview.start
    end

    def start_webserver
      @webserver = Crimson::WebServer.new
      Thin::Server.start(@webserver, webserver_host, webserver_port, signals: false)
    end

    def start_websocket
      WebSocket::EventMachine::Server
        .start(host: websocket_host, port: websocket_port) { |ws| Crimson::ClientInteractor.new(ws) }
    end
  end
end
