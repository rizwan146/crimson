# frozen_string_literal: true

module Crimson
  module Listener
    class Base
      protected

      attr_writer :model, :updater, :events

      public

      attr_reader :model, :widget, :updater, :events

      def initialize(opts = {})
        self.model = opts[:model]
        self.events = opts[:events]
        self.widget = opts[:widget]
        self.updater = opts[:updater]
      end

      def widget=(w)
        events.each do |event|
          widget&.un(event, &method(:update))
        end

        @widget = w

        events.each do |event|
          widget&.on(event, &method(:update))
        end
      end

      def update(meta)
        updater&.call(model, widget, meta)
      end
    end
  end
end
