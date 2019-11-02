# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

main_widget = Crimson.Root do
  form = form {
    set :onsubmit, "return false"
    input = input {
      set :type, :text
      set :name, :data
    }
  }
  list = ul {}

  model = Crimson::Model::Base.new(%w[1 2 3 4])

  renderer = Crimson::Renderer::List.new(
    model: model,
    view: list,
    updater: lambda { |item|
      div { set :innerHTML, item }
    }
  )

  listener = Crimson::Listener::Base.new(
    model: model,
    view: form,
    events: [:submit],
    updater: lambda { |model, meta|
      model.data.push(meta[:data])
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
