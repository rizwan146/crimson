
module Crimson
  class Destroyer
    def initialize()

    end

    def destroy(id)
      message = {
        id: id,
        action: 'destroy'
      }.to_json

      app.clients.each { |client| client.send(message) }
    end

    def app
      Crimson::Application.instance
    end
  end
end