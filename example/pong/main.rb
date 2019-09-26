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

    self.style = {
      'min-height': '100vh',
      'display': 'flex',
      'align-items': 'center',
    }

    @title = H3 "Crimson" do
      self.style = {
        'max-height': '40px',
        'text-align': 'center',
        'color': '#fff'
      }
    end

    @username = Input(:text) do
      set :placeholder, :Username

      self.css_class += [:"form-control"]
      self.style = {
        'max-height': '40px'
      }
    end

    @password = Input(:password) do
      set :placeholder, :Password

      self.css_class += [:"form-control"]
      self.style = {
        'max-height': '40px'
      }
    end

    @submit = Input(:submit) do
      set :value, :Login

      self.css_class += [:"btn"]
      self.style = {
        'max-height': '40px',
        'font-weight': '600',
        'width': '50%',
        'color': '#282726',
        'background-color': '#fff',
        'border': 'none',
        'border-radius': '1.5rem',
        'padding': '2%'
      }
    end

    # this prevent the page from refreshing when we submit
    set :onsubmit, :'return false'

    VerticalLayout [@title, @username, @password, @submit] do
      self.style = {
        'margin': '0 auto',
        'width': '350px',
        'height': '300px',
        'padding': '30px 30px 30px 30px',
        'background': '#B00020',
        'box-shadow': '0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19)'
      }
    end

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