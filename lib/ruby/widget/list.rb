require_relative '../object'

module Crimson
  class ListItem < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :li)
    end
  end

  class List < Widget
    def initialize(type, parent: app.root)
      raise ArgumentError unless [:ul, :ol].include?(type)
      super(parent: parent, tag: type)
    end
  end
end