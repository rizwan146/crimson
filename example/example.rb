# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

main_widget = Crimson.Root do
  list = List(:ul)
  input = Input(:text)
  
  model = Crimson::Model.new(["1","2", "3", "4"])
  
  renderer = Crimson::Renderer.new(
    model: model,
    widget: list,
    updater: ->(model, widget) {
      model.data.each { |item| widget.ListItem() { Text(item) } }
    }
  )

  listener = Crimson::Listener.new(
    model: model,
    widget: input,
    events: [:keyup],
    updater: ->(model, widget, meta) {
      if meta[:event][:key] == "Enter"
        widget&.remove_all
        
        model.data.push( meta[:value] )
        model.force_commit

        widget.set(:value, "")
      end
    }
  )

  model.commit
end

Crimson.on_connect do |client|
  client.create(main_widget)
end

Crimson.on_disconnect do |client|
  client.destroy(main_widget)
end