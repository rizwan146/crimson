require_relative 'base'

module Crimson
  module Element
    class Image < Base
      attr_reader :src

      def initialize(source, parent: app.root)
        super(parent: parent, tag: :img)
        self.src = source
      end

      def src=(source)
        @src = source
        attributes.merge!(src: source)
        update(attributes: attributes)
      end
    end
  end
end