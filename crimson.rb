# frozen_string_literal: true

require_relative 'lib/ruby/base'
require_relative 'lib/ruby/client-interactor'
require_relative 'lib/ruby/creater'
require_relative 'lib/ruby/updater'
require_relative 'lib/ruby/destroyer'

CrimsonApplication = Crimson::Application.new()

module Crimson
  def self.host
    CrimsonApplication.host
  end

  def self.host=(host)
    CrimsonApplication.host = host
  end

  def self.port
    CrimsonApplication.port
  end

  def self.port=(port)
    CrimsonApplication.port = port
  end
end

at_exit { CrimsonApplication.run }
