# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

text1 = Crimson::Text.new 'Hello World'
text2 = Crimson::Text.new 'Hello World2'

checkbox = Crimson::Checkbox.new checked: true

button = Crimson::Button.new 'MyButton'
button.on(:click) { checkbox.toggle }

textfield = Crimson::TextField.new placeholder: 'Hello World', value: 'Yes'

Crimson::Radio.new
Crimson::Radio.new
Crimson::Radio.new
Crimson::Radio.new

dropdown = Crimson::Dropdown.new('I', 'like', 'pie', 'yes')
dropdown.on(:change) { |meta| dropdown.selected = meta['value'] }

list = Crimson::List.new(
  Crimson::Text.new('item1'),
  Crimson::Text.new('item2'),
  Crimson::Text.new('item3')
)

textfield.on(:keypress) do |meta|
  if meta['event']['key'] == 'Enter'
    textfield.value = meta['value']
    list.append Crimson::Text.new(textfield.value)
  end
end

button.on(:click) do |_meta|
  list.delete list.first unless list.empty?
end

add_row_button = Crimson::Button.new 'Add Row'
rmv_row_button = Crimson::Button.new 'Remove Row'
insert_col_button = Crimson::Button.new 'Insert Column'

valuefield = Crimson::TextField.new placeholder: 'Value'
rowfield = Crimson::TextField.new placeholder: 'Row'
colfield = Crimson::TextField.new placeholder: 'Col'

valuefield.on(:keyup) do |meta|
  valuefield.value = meta['value']
end

rowfield.on(:keyup) do |meta|
  rowfield.value = meta['value']
end

colfield.on(:keyup) do |meta|
  colfield.value = meta['value']
end

table = Crimson::Table.new(
  %w[Row1 Col2]
)

add_row_button.on(:click) do
  add_column_button = Crimson::Button.new 'Add Column'
  rmv_column_button = Crimson::Button.new 'Remove Column'

  row = table.append ["Row#{table.rows.size + 1}", add_column_button, rmv_column_button]

  add_column_button.on(:click) do
    row.append "Col#{row.columns.size + 1}"
  end

  rmv_column_button.on(:click) do
    row.delete row.columns.last unless row.columns.size <= 3
  end
end

rmv_row_button.on(:click) do
  table.delete table.rows.last unless table.rows.empty?
end

insert_col_button.on(:click) do
  begin
    row = Integer(rowfield.value)
    col = Integer(colfield.value)
    val = valuefield.value
    table[row].insert(col, val)
  rescue IndexError
    puts "Error: Index out of bounds!"
  rescue ArgumentError
    puts "Error: Expected numeric but got a string"
  end
end

Crimson::Image.new('https://images.template.net/wp-content/uploads/2016/04/26122303/Cool-Lion-Colorful-Art.jpg')
