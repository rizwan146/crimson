require 'observer'

module Crimson
  module Model
    class Base
      include Observable

      attr_reader :data

      def initialize(data)
        self.data = data
      end

      def data=(d)
        changed if d != @data
        @data = d
      end

      def commit
        notify_observers
      end

      def force_commit
        changed
        commit
      end
    end
  end
end