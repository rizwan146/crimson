# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

main_widget = Crimson.Root do
  input = input {}
  list = ul {}
  
  model = Crimson::Model::Base.new(["1","2", "3", "4"])
  
  renderer = Crimson::Renderer::List.new(
    model: model,
    view: list,
    updater: ->(item) {
      div { set :innerHTML, item }
    }
  )

  listener = Crimson::Listener::Base.new(
    model: model,
    view: input,
    events: [:keyup],
    updater: ->(model, widget, meta) {
      if meta[:event][:key] == "Enter"
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