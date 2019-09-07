
module Crimson
  class Destroyer
    def initialize()

    end

    def destroy(id, clients = app.clients)
      message = {
        id: id,
        action: 'destroy'
      }.to_json

      clients.each { |client| client.send(message) }
    end

    def app
      Crimson::Application.instance
    end
  end
end