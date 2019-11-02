# frozen_string_literal: true

require 'benchmark'

module Crimson
  module Renderer
    class Base
      protected

      attr_writer :view, :updater

      public

      attr_reader :model, :view, :updater

      def initialize(opts = {})
        self.model = opts[:model]
        self.view = opts[:view]
        self.updater = opts[:updater]
      end

      def model=(m)
        @model&.delete_observer(self)
        @model = m
        @model&.add_observer(self)
      end

      def child_generator
        [updater&.call(model)].reject(&:nil?)
      end

      def update
        child_generator.each_with_index(&method(:refresh))
      end

      def refresh(child, index)
        index < view.children.length ? view.replace(index, child) : view.append(child)
      end
    end
  end
end
