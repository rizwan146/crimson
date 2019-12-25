# frozen_string_literal: true

require_relative '../crimson'

include Crimson

server = Server.new

main = Html.builder do
  Div {
    Label(innerHTML: "Don't press this button...")
    
    Button {
      
    }
  }
end

server.on_connect do |client|
  puts "connected"

  client.observe(main)
end

server.on_disconnect do |client|
  puts "disconnected"
end

server.run