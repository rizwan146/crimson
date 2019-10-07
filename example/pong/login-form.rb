require_relative 'user-manager'
require_relative '../../crimson'

class LoginForm < Crimson::Form
    def initialize(parent: app.root)
      super(parent: parent)
  
      self.style = {
        'min-height': '100vh',
        'display': 'flex',
        'align-items': 'center',
      }
  
      @title = H3 "pong" do
        self.css_class += [:"text-primary"]
        self.style = {
          'max-height': '40px',
          'text-align': 'center',
          'user-select': 'none'
        }
      end
  
      @username_input = Input(:text) do
        set :placeholder, :Username
  
        self.css_class += [:"form-control"]
        self.style = {
          'max-height': '40px'
        }
      end
  
      @password_input = Input(:password) do
        set :placeholder, :Password
        self.css_class += [:"form-control"]
        self.style = {
          'max-height': '40px'
        }
      end
  
      @submit_button = Input(:submit) do
        set :value, :Login
        set :onclick, 'this.blur();' # remove the border

        self.css_class += [:"btn", :"btn-primary"]
        self.style = {
          'max-height': '40px'
        }
      end
  
      VerticalLayout [@title, @username_input, @password_input, @submit_button] do
        self.style = {
          'margin': '0 auto',
          'width': '350px',
          'height': '300px',
          'padding': '30px 30px 30px 30px',
          'border-radius': '10px',
          'box-shadow': '0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19)'
        }
      end

      on(:submit, &method(:on_submit))
    end
  
    def on_submit(meta)
      user_manager = UserManager.instance
      username = @username_input.value
      password = @password_input.value
      
      if user_manager.authenticate(username, password)
        @on_success&.call( user_manager[username] )
      else
        @on_failure&.call
      end
    end

    def on_success(&block)
        @on_success = block
    end

    def on_failure(&block)
        @on_failure = block
    end
  end