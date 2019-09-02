# frozen_string_literal: true

require 'thin'
require 'sinatra/base'
require_relative '../crimson'

# run Crimson manually in the event machine
Crimson.run = false

class WebServer < Sinatra::Base
  set :public_folder, "#{__dir__}/../"
  get '/' do
    return File.read("#{__dir__}/example.html")
  end
end

text1 = Crimson::Text.new "Hello World"
text2 = Crimson::Text.new "Hello World2"

checkbox = Crimson::Checkbox.new checked: true

button = Crimson::Button.new 'MyButton'
button.on(:click) { checkbox.toggle }

textfield = Crimson::TextField.new placeholder: "Hello World", value: "Yes"

Crimson::Radio.new
Crimson::Radio.new
Crimson::Radio.new
Crimson::Radio.new

dropdown = Crimson::Dropdown.new("I", "like", "pie", "yes")
dropdown.on(:change) { |meta| dropdown.selected = meta["value"] }

list = Crimson::List.new(
  Crimson::Text.new("item1"),
  Crimson::Text.new("item2"),
  Crimson::Text.new("item3"),
)

textfield.on(:keypress) { |meta|
  if meta["event"]["key"] == "Enter"
    textfield.value = meta["value"]
    list.add_item Crimson::Text.new(textfield.value)
  end
}

button.on(:click) { |meta|
  list.remove_item list.first unless list.empty?
}

puts 'Server started at http://localhost:9000'
EM.run do
  websrv = WebServer.new
  Crimson::Application.instance.start
  Thin::Server.start(websrv, '0.0.0.0', 9000, signals: false)
end
