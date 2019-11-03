# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Renderer
    class List < Base
      attr_accessor :wrapper

      def initialize(opts = {})
        default_opts = { wrapper: :li }
        opts = default_opts.merge(opts)

        super(opts)

        self.wrapper = opts[:wrapper]
      end

      def generate_children
        model.data.map do |child_model|
          child = nil
          if child_model.changed?
            child = Element.new(tag: wrapper)
            child.append(generator&.call(child_model))
          end
          child
        end
      end
    end
  end
end
