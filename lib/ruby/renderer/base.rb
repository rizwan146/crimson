# frozen_string_literal: true

require 'benchmark'

module Crimson
  module Renderer
    class Base
      protected

      attr_writer :view, :generator

      public

      attr_reader :model, :view, :generator

      def initialize(opts = {})
        self.model = opts[:model]
        self.view = opts[:view]
        self.generator = opts[:generator]
      end

      def model=(m)
        @model&.delete_observer(self)
        @model = m
        @model&.add_observer(self)
      end

      def generate_children
        [generator&.call(model)]
      end

      def update
        children = generate_children
        children.each_with_index(&method(:refresh))
      end

      def refresh(child, index)
        unless child.nil?
          index < view.children.length ? view.replace(index, child) : view.append(child)
        end
      end
    end
  end
end
