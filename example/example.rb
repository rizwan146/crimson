# frozen_string_literal: true

require_relative '../crimson'

include Crimson

server = Server.new

server.on_connect do |client|
  puts "#{client.id} connected"
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run