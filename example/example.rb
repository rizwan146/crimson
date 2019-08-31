# frozen_string_literal: true

require 'thin'
require 'sinatra/base'
require_relative '../lib/ruby/base'

class WebServer < Sinatra::Base
  set :public_folder, "#{__dir__}/../"
  get '/' do
    return File.read("#{__dir__}/example.html")
  end
end

puts 'Server started at http://localhost:9000'

EM.run do
  websrv = WebServer.new
  app = Crimson::Application.new
  app.start_server
  Thin::Server.start(websrv, '0.0.0.0', 9000, signals: false)
end
