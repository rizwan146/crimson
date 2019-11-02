# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

main_widget = Crimson.Root do
  input = input {}
  list = ul {}

  model = Crimson::Model::Base.new(%w[1 2 3 4])

  renderer = Crimson::Renderer::List.new(
    model: model,
    view: list,
    updater: lambda { |item|
      div { set :innerHTML, item }
    }
  )

  listener = Crimson::Listener::Keyboard.new(
    model: model,
    view: input,
    filters: [:Enter],
    updater: lambda { |model, meta|
      model.data.push(meta[:value])
      model.force_commit
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
