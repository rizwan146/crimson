# frozen_string_literal: true

require_relative 'lib/ruby/base'
require_relative 'lib/ruby/client-interactor'
require_relative 'lib/ruby/object'
require_relative 'lib/ruby/widget'
require_relative 'lib/ruby/layout'
require_relative 'lib/ruby/model'
require_relative 'lib/ruby/renderer'
require_relative 'lib/ruby/listener'

module Crimson
  @@webserver_enabled = false
  @@websocket_enabled = true
  @@webview_enabled = false

  def self.Root(&block)
    widget = Widget.new
    widget.instance_eval(&block)

    widget
  end

  def self.on_connect(&block)
    Crimson::Application.instance.on_connect = block
  end

  def self.on_disconnect(&block)
    Crimson::Application.instance.on_disconnect = block
  end

  def self.logger
    Crimson::Application.instance.logger
  end

  def self.logger=(logger)
    Crimson::Application.instance.logger = logger
  end

  def self.name
    Crimson::Application.instance.name
  end

  def self.name=(name)
    Crimson::Application.instance.name = name
  end

  def self.webserver_host
    Crimson::Application.instance.webserver_host
  end

  def self.webserver_host=(host)
    Crimson::Application.instance.webserver_host = host
  end

  def self.webserver_port
    Crimson::Application.instance.webserver_port
  end

  def self.webserver_port=(port)
    Crimson::Application.instance.webserver_port = port
  end

  def self.websocket_host
    Crimson::Application.instance.websocket_host
  end

  def self.websocket_host=(host)
    Crimson::Application.instance.websocket_host = host
  end

  def self.websocket_port
    Crimson::Application.instance.websocket_port
  end

  def self.websocket_port=(port)
    Crimson::Application.instance.webserver_port = port
  end

  def self.webserver_enabled
    @@webserver_enabled
  end

  def self.webserver_enabled=(bool)
    @@webserver_enabled = bool
  end

  def self.websocket_enabled
    @@websocket_enabled
  end

  def self.websocket_enabled=(bool)
    @@websocket_enabled = bool
  end

  def self.webview_enabled
    @@webview_enabled
  end

  def self.webview_enabled=(bool)
    @@webview_enabled = bool
  end
end

at_exit do
  Crimson::Application.instance.run(
    websocket_enabled: Crimson.websocket_enabled,
    webserver_enabled: Crimson.webserver_enabled,
    webview_enabled: Crimson.webserver_enabled
  )
end
