# frozen_string_literal: true

require_relative '../crimson'
require_relative '../lib/ruby/widgets/desktop'
require_relative '../lib/ruby/widgets/window'
require_relative '../lib/ruby/widgets/form'
require_relative '../lib/ruby/widgets/input'


server = Crimson::Server.new

desktop = Crimson::Desktop.new
desktop.style.backgroundColor = "white"

username = Crimson::Input.new(:text)
username.name = "username"
username.placeholder = "Username"
username.style.width = "50%"
username.style.height = "30px"

password = Crimson::Input.new(:password)
password.name = "password"
password.placeholder = "Password"
password.style.width = "50%"
password.style.height = "30px"

submit = Crimson::Input.new(:submit)
submit.value = "Login"
submit.style.width = "50%"
submit.style.height = "30px"

form = Crimson::Form.new
form.add(username)
form.add(password)
form.add(submit)

form.on("submit") do |data|
  puts "Username: #{data.username}, Password: #{data.password}" 
end

login = desktop.create_window("Login", "400px", "200px")
login.titlebar.buttons.each(&:hide)
login.resizable = false
login.content = form

desktop.commit_tree!

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(desktop)
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

server.run