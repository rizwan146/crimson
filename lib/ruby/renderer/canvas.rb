# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Renderer
    class Context
      attr_reader :canvas, :type

      def initialize(canvas, type)
        raise ArgumentError unless canvas.is_a?(Canvas)

        @canvas = canvas
        @type = type
      end

      def method_missing(name, *args)
        canvas.invoke(
          method: name,
          args: args,
          invoker: :canvas,
          type: type
        )
      end
    end

    class Canvas < Base
      def initialize(width, height, parent: app.root)
        super(parent: parent, tag: :canvas)
        set :width, width
        set :height, height
      end

      def context(type)
        Context.new(self, type)
      end
    end
  end
end
