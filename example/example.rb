# frozen_string_literal: true

require 'hashie'
require_relative '../crimson'


server = Crimson::Server.new

object = Crimson::Object.new("div")
object2 = Crimson::Object.new("div")

object.style = {
  "color": "white",
  "background-color": "black",
  "height": "100vh",
  "width": "100vw"
}

object.innerHTML = "Hello World"

object.commit!

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(object)
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run