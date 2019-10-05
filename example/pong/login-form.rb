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
  
      @title = H3 "Crimson" do
        self.style = {
          'max-height': '40px',
          'text-align': 'center',
          'color': '#fff'
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
  
      VerticalLayout [@title, @username_input, @password_input, @submit_button] do
        self.style = {
          'margin': '0 auto',
          'width': '350px',
          'height': '300px',
          'padding': '30px 30px 30px 30px',
          'background': '#B00020',
          'box-shadow': '0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19)'
        }
      end

      on(:submit, &method(:on_submit))
    end
  
    def on_submit(meta)
      username = @username_input.value
      password = @password_input.value
      
      if UserManager.instance.authenticate(username, password)
        @on_success&.call
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