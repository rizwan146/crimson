# frozen_string_literal: true

require 'crimson'
require 'crimson/widgets/desktop'
require 'crimson/widgets/window'
require 'crimson/widgets/form'
require 'crimson/widgets/input'

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
submit.style.marginTop = '20px'
submit.style.width = "50%"
submit.style.height = "30px"
submit.style.backgroundColor = 'rgba(46, 204, 113, 1)'
submit.style.color = 'white'
submit.style.border = 0

form = Crimson::Form.new
form.style.display = 'flex'
form.style.justifyContent = 'center'
form.style.alignItems = 'center'
form.style.flexDirection = 'column'
form.style.height = "100%"
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

server = Crimson::Server.new

server.on_connect do |client|
  puts "#{client.id} connected"

  client.observe(desktop)
end

server.on_disconnect do |client|
  puts "#{client.id} disconnected"
end

use Rack::Static, :root => Crimson::Server.root_path
run server