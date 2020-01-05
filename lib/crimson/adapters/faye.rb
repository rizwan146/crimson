require 'faye/websocket'

module Crimson
  module Adapters
    class Faye < SimpleDelegator
      def initialize(ws)
        @ws = ws
        super(@ws)
      end

      def write(message)
        @ws.send(message)
      end
    end
  end
end