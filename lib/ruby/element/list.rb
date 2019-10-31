require_relative 'base'

module Crimson
  module Element
    class ListItem < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :li)
      end
    end

    class List < Base
      def initialize(type, parent: app.root)
        raise ArgumentError unless [:ul, :ol].include?(type)
        super(parent: parent, tag: type)
      end
    end
  end
end