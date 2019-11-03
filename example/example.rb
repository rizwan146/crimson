# frozen_string_literal: true

require_relative '../crimson'

Crimson.logger.level = Logger::DEBUG
Crimson.webserver_enabled = true
Crimson.webserver_host = 'localhost'

include Crimson

main_widget = div {
  form = form {
    set :onsubmit, "return false"
    
    input {
      set :type, :text
      set :name, :data
    }
  }

  list = ul {}

  model = Model::List.new(%w[1 2 3 4])

  renderer = Renderer::List.new(
    model: model,
    view: list,
    generator: lambda { |model|
      div { set :innerHTML, model.data }
    }
  )

  listener = Listener::Base.new(
    model: model,
    view: form,
    events: [:submit],
    updater: lambda { |model, meta|
      model << meta[:data]
      model.commit
    }
  )

  model.commit
}

Crimson.on_connect { |client| client.create(main_widget) }

Crimson.on_disconnect { |client| client.destroy(main_widget) }
