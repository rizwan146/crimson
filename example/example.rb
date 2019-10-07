# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

main_widget = Crimson.Root do
  HorizontalLayout do
    Text 'Hello World'
    Text 'Hello World2'
  end

  VerticalLayout do
    checkbox = Checkbox { check }

    button = Button 'MyButton'

    # Any CSS style is supported
    # '-' not supported, need to use single quote
    button.style = { color: '#fff',
                     'background-color': '#dc3545',
                     'border-color': '#dc3545',
                     'font-family': 'Times New Roman, Times, serif',
                     'font-weight': '400',
                     'text-align': 'center',
                     padding: '.375rem .75rem',
                     'font-size': '1rem',
                     'line-height': '1.5',
                     'border-radius': '.25rem',
                     'font-style': 'italic' }

    button.css_class = ['cool']
    button.css_class += ['btn', 'btn-danger']

    textfield = TextField do
      self.placeholder = 'Hello World'
      self.value = 'Yes'
    end

    HorizontalLayout do
      Radio {}
      Radio {}
      Radio {}
    end

    Dropdown 'I', 'like', 'pie', 'yes' do
      on(:change) { |meta| self.selected = meta['value'] }
    end

    list = List do
      append Text 'item1'
      append Text 'item2'
      append Text 'item3'
    end

    textfield.on(:keypress) do |meta|
      if meta[:event][:key] == 'Enter'
        textfield.value = meta[:value]
        list.append Crimson::Text.new(textfield.value)
      end
    end

    button.on(:click) do |_meta|
      checkbox.toggle
      list.delete list.first unless list.empty?
    end
    
    add_row_button = Button 'Add Row'
    rmv_row_button = Button 'Remove Row'
    insert_col_button = Button 'Insert Column'
    
    HorizontalLayout [add_row_button, rmv_row_button, insert_col_button]

    valuefield = TextField { self.placeholder = 'Value' }
    rowfield = TextField { self.placeholder = 'Row' }
    colfield = TextField { self.placeholder = 'Col' }

    HorizontalLayout [valuefield, rowfield, colfield]

    valuefield.on(:keyup) do |meta|
      valuefield.value = meta[:value]
    end

    rowfield.on(:keyup) do |meta|
      rowfield.value = meta[:value]
    end

    colfield.on(:keyup) do |meta|
      colfield.value = meta[:value]
    end

    table = Table do
      Row do
        Column() { Text "Hello" }
        Column() { Button "I do nothing" }
      end
    end
    
    Image 'https://images.template.net/wp-content/uploads/2016/04/26122303/Cool-Lion-Colorful-Art.jpg'
  end
end

Crimson.on_connect do |client|
  client.create(main_widget)
end

Crimson.on_disconnect do |client|
  client.destroy(main_widget)
end