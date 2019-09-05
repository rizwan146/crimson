# frozen_string_literal: true

require_relative '../crimson'

Crimson.webserver_host = 'localhost'

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

Crimson::Image.new("https://images.template.net/wp-content/uploads/2016/04/26122303/Cool-Lion-Colorful-Art.jpg")