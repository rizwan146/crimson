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

      def child_generator
        model.data.map do |item|
          child = Element.new(tag: wrapper)
          child.append(updater&.call(item))
          child
        end
      end
    end
  end
end