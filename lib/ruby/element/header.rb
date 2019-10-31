require_relative 'base'

module Crimson
  module Element
    class Header < Base
      def initialize(size, parent: app.root)
        super(parent: parent, value: value, tag: :"h#{size}")
      end
    end
  end
end