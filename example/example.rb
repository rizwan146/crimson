# frozen_string_literal: true

require_relative '../crimson'


server = Crimson::Server.new

object = Crimson::Object.new("div")
child = Crimson::Object.new("div")

child.style = {
  "background-color": "green",
  "height": "100px",
  "width": "100px",
}

child.on("click") do |data|
  puts data.to_s
end

object.style = {
  "color": "white",
  "background-color": "black",
  "height": "100vh",
  "width": "100vw"
}
object.innerHTML = "Hello World"
object.add(child)
object.commit_tree!

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(object)
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run