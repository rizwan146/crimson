
module Crimson
    class Invoker
      def initialize()
  
      end
  
      def invoke(id, method, args, clients = app.clients)
        message = {
          id: id,
          method: method,
          args: args,
          action: 'invoke'
        }.to_json
  
        clients.each { |client| client.send(message) }
      end
  
      def app
        Crimson::Application.instance
      end
    end
  end