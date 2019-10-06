# Crimson
## A library for creating web based GUIs using Ruby

[![BCH compliance](https://bettercodehub.com/edge/badge/rizwan146/crimson?branch=master)](https://bettercodehub.com/)
[![Maintainability](https://api.codeclimate.com/v1/badges/ff7408645e0200a86bb4/maintainability)](https://codeclimate.com/github/rizwan146/crimson/maintainability)

Implementation currently in progress..

run ruby example/example.rb

Required gems:
thin sinatra eventmachine websocket-eventmachine-server

# Using this Library

A simple Hello World application:
```ruby
require 'crimson'

# Will launch a web server to view the app @ localhost:9000
Crimson.webserver_enabled = true

text = Crimson::Text.new "Hello World"

# Created objects are simply appended to the <crimson> DOM element
# that corresponds to this app
Crimson::Text.new "Hello World2"
Crimson::Text.new "I LIKE MANGOS"
```

There are two types of Crimson objects that can be created.

## Data objects

Data objects have a value attribute that corresponds to setting the
innerHTML of that object's DOM element

```ruby
data = Crimson::Data.new
data.value = "Hello World"

# The Text class is an example of a data object
text = Crimson::Text.new "I am data"
text.value = "I am new data"
```

## Widget objects

Widget objects are essentially containers that hold other
widget and data objects. They are meant to represent DOM elements
that can have children nodes (for example, an HTML table element)

```ruby
widget = Crimson::Widget.new
text = Crimson::Text.new "Some Text"

# append the text as a child of the widget's DOM element
widget.add_child text

# or, equivalently you can set the child's parent
text2 = Crimson::Text.new(parent: widget)
```

In summary, the only difference between the two types of objects is that
data objects can not have children, and widget objects cannot be set a value. 
Using these two components, it should be possible to generate any HTML element.

## Modifying DOM properties of an object

### Attributes

It is possible for any object to modify their DOM attributes as they wish:
```ruby
# Append a <textarea></textarea> DOM element
textarea = Crimson::Widget.new tag: 'textarea'

# The attributes we would like to change for the text area
attributes = {
  value: "",
  placeholder: "Search",
  rows: 1,
  cols: 20
}

# Generate the update message and send the changes to the client
textarea.emit textarea.update(attributes: attributes)

# While it is possible to do the steps above, it is not preferred.
# Instead, you should make a class that perform those steps
# internally. In this case, we've already made a TextArea class.
textarea = Crimson::TextArea.new
textarea.value = "mango"
textarea.placeholder = "Search for your favorite fruit..."
textarea.rows = 1
textarea.cols = 30
```

### Styles

Objects can be styled as follows:

```ruby
button = Crimson::Button.new "Click Me"
button.style = {
  'color': '#fff',
  'background-color': '#dc3545',
  'border-color': '#dc3545',
  'font-family': 'Times New Roman, Times, serif',
  'font-weight': '400',
  'text-align': 'center',
  'padding': '.375rem .75rem',
  'font-size': '1rem',
  'line-height': '1.5',
  'border-radius': '.25rem',
  'font-style': 'italic'
}
```

### Events

Events are supported, however at the moment, each object is limited to only one event handler per
event. This will indeed change when time permits. All the typical DOM events are supported. For example:

```ruby
textfield = Crimson::TextArea.new

textfield.on(:mouseenter) do |meta|
  textfield.style = { opacity: 1 }
end

textfield.on(:mouseleave) do |meta|
  textfield.style = { opacity: 0.5 }
end

textfield.on(:keypress) do |meta|
  keypressed = meta[:event][:key]
  if keypressed == 'Enter'
    # update the textfield.value attribute
    textfield.value = meta[:value]
    search_for textfield.value
  end
end
```

### Quick Object Construction

Initializing using new and specifying the parent for an object can become
quite a hasle. Thus, the prefered method for writing apps is to use the quick
constructor:

```ruby
require 'crimson'

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
```

![alt text](https://github.com/rizwan146/crimson/blob/master/doc/images/temperature-readme-example.PNG "Temperature Logger Example")
