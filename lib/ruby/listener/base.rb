# frozen_string_literal: true

module Crimson
  module Listener
    class Base
      protected

      attr_writer :model, :updater, :events

      public

      attr_reader :model, :view, :updater, :events

      def initialize(opts = {})
        self.model = opts[:model]
        self.events = opts[:events]
        self.view = opts[:view]
        self.updater = opts[:updater]
      end

      def view=(w)
        events.each do |event|
          view&.un(event, &method(:update))
        end

        @view = w

        events.each do |event|
          view&.on(event, &method(:update))
        end
      end

      def update(meta)
        updater&.call(model, view, meta)
      end
    end
  end
end
