# frozen_string_literal: true

require 'thin'
require 'sinatra/base'
require_relative '../crimson'

# run Crimson manually in the event machine
Crimson.run = false

class WebServer < Sinatra::Base
  set :public_folder, "#{__dir__}/../"
  get '/' do
    return File.read("#{__dir__}/example.html")
  end
end

text1 = Crimson::Text.new "Hello World"
text2 = Crimson::Text.new "Hello World2"

button = Crimson::Button.new 'MyButton'
button.on(:click) { text1.value += "!!!" }

puts 'Server started at http://localhost:9000'
EM.run do
  websrv = WebServer.new
  Crimson::Application.instance.start
  Thin::Server.start(websrv, '0.0.0.0', 9000, signals: false)
end
