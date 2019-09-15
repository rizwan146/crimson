# Temperature Logging Example from README
require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true

# Root references the root object
Crimson.Root do
  
  TextField do
    # These blocks are really just instance_evals. You can call
    # any method that belongs to text area.
    self.value = "Some text"
    self.placeholder = "Please enter some text"
  end

  List do
    # The following text objects will be added as
    # children to this list object
    append Text "Hello world"
    append Text "Welcome to my first crimson app!"

    self.style = { 'background-color': 'red', 'color': 'white' }
  end

  table = Table ["Time", "Temperature (C)"] do
    Row ["9/14/2019 10:42", "21"]

    self.style = {
        'border': '1px solid black',
        'border-collapse': 'collapse',
        'height': '30px',
        'width': '400px',
        'text-align': 'center',
        'padding': '10px'
    }
  end

  button = Button "Log Temperature Reading" do
    on(:click) do
      time = Time.now.strftime("%d/%m/%Y %H:%M")
      temperature = rand(-30..30)

      table.append [time, temperature]
    end
  end

end