require 'faye/websocket'

module Crimson
  module Adapters
    class Faye < SimpleDelegator
      def initialize(env)
        super(Faye::WebSocket.new(env))
      end

      def write(message)
        self.send(message)
      end
    end
  end
end