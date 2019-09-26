require_relative '../../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true

# class RegisterForm

class LoginForm < Crimson::Form
  protected
  attr_accessor :client

  public
  def initialize(client, parent: app.root)
    super(parent: parent)

    @username = Input(:text) { set :placeholder, :Username }
    @password = Input(:password) { set :placeholder, :Password }
    @submit = Input(:submit) { set :value, :Login }

    # this prevent the page from refreshing when we submit
    set :onsubmit, :'return false'

    VerticalLayout [@username, @password, @submit]

    self.client = client
    client.observe(self)
    emit :create
  end

  def on_login_success
    emit :destroy
    client.stop_observing(self)
  end

  def on_login_fail

  end
end

Crimson.on_connect do |client|
  # Importing Bootstrap and its dependencies
  client.import :js, :'https://code.jquery.com/jquery-3.3.1.slim.min.js'
  client.import :js, :'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js'
  client.import :js, :'https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js'
  client.import :css, :'https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'

  LoginForm.new(client)
end

Crimson.on_disconnect do |client|

end