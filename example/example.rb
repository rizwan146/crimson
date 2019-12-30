# frozen_string_literal: true

require_relative '../crimson'
require_relative '../lib/ruby/widgets/desktop'
require_relative '../lib/ruby/widgets/window'


server = Crimson::Server.new

desktop = Crimson::Desktop.new
desktop.style.backgroundColor = "white"
window = desktop.create_window("Login")

desktop.commit_tree!

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(desktop)
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run