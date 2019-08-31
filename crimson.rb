# frozen_string_literal: true

require 'singleton'

require_relative 'lib/ruby/client-interactor'
require_relative 'lib/ruby/creater'
require_relative 'lib/ruby/updater'
require_relative 'lib/ruby/destroyer'

module Crimson
  @@host = '0.0.0.0'
  @@port = 10_000

  def self.host
    @@host
  end

  def self.host=(host)
    @@host = host
  end

  def self.port
    @@port
  end

  def self.port=(port)
    @@port = port
  end

  class Application
    include Singleton

    attr_reader :objects

    def initialize
      @clients = []
      @objects = {}
    end

    def run
      EM.run do
        WebSocket::EventMachine::Server
          .start(host: Crimson.host, port: Crimson.port) { |ws| @clients << ClientInteractor.new(ws) }
      end
    end
  end
end

at_exit { Crimson::Application.instance.run }
