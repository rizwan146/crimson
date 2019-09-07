# frozen_string_literal: true

require 'sinatra/base'

module Crimson
  class WebServer < Sinatra::Base
    set :public_folder, "#{__dir__}/../../"
    get '/' do
      return File.read("#{__dir__}/webserver/crimson.html")
    end
  end
end
