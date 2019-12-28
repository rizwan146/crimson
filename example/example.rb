# frozen_string_literal: true

require 'hashie'
require_relative '../crimson'


server = Crimson::Server.new

object = Crimson::Object.new("div")
child = Crimson::Object.new("div")

child.style = {
  "background-color": "green",
  "height": "100px",
  "width": "100px",
}

object.style = {
  "color": "white",
  "background-color": "black",
  "height": "100vh",
  "width": "100vw"
}

object.innerHTML = "Hello World"

object.add(child)

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(object)

  object.commit_tree!
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run