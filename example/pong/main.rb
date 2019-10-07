require_relative '../../crimson'
require_relative 'login-form'
require_relative 'game-panel'
require_relative 'game'

Crimson.logger.level = Logger::WARN
Crimson.webserver_enabled = true

Crimson.on_connect do |client|
  # Importing Bootstrap and its dependencies
  client.import :js, :'https://code.jquery.com/jquery-3.3.1.slim.min.js'
  client.import :js, :'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'
  client.import :js, :'https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'
  client.import :css, :'https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'

  login_form = LoginForm.new
  # client.create(login_form)
  canvas = Crimson::Canvas.new(800, 600)
  client.create( canvas )
  
  context = canvas.context('2d')
  context.moveTo(0, 0)
  context.lineTo(200, 100)
  context.stroke()

  login_form.on_success do |user|
    client.destroy(login_form)
    # client.create(GamePanel.new(user))
  end
end

Crimson.on_disconnect do |client|

end