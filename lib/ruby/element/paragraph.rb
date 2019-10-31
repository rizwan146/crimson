require_relative 'base'

module Crimson
  module Element
    class Paragraph < Base
      def initialize(value, parent: app.root)
        super(parent: parent, tag: :p)
      end
    end
  end
end