# frozen_string_literal: true

require_relative 'lib/ruby/base'
require_relative 'lib/ruby/client-interactor'
require_relative 'lib/ruby/creator'
require_relative 'lib/ruby/updater'
require_relative 'lib/ruby/destroyer'
require_relative 'lib/ruby/object'
require_relative 'lib/ruby/widget'

module Crimson
  @@webserver_enabled = true
  @@websocket_enabled = true
  @@webview_enabled = true

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

at_exit { Crimson::Application.instance.run(
  websocket_enabled: Crimson.websocket_enabled,
  webserver_enabled: Crimson.webserver_enabled,
  webview_enabled: Crimson.webserver_enabled
) }
