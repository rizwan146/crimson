# frozen_string_literal: true

require_relative 'lib/ruby/base'
require_relative 'lib/ruby/client-interactor'
require_relative 'lib/ruby/creator'
require_relative 'lib/ruby/updater'
require_relative 'lib/ruby/destroyer'
require_relative 'lib/ruby/object'
require_relative 'lib/ruby/widget'

module Crimson
  @@run = true

  def self.name
    Crimson::Application.instance.name
  end

  def self.name=(name)
    Crimson::Application.instance.name = name
  end

  def self.host
    Crimson::Application.instance.host
  end

  def self.host=(host)
    Crimson::Application.instance.host = host
  end

  def self.port
    Crimson::Application.instance.port
  end

  def self.port=(port)
    Crimson::Application.instance.port = port
  end

  def self.run
    @@run
  end

  def self.run=(run)
    @@run = run
  end
end

at_exit { Crimson::Application.instance.run if Crimson.run }
