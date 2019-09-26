module Crimson
  class Frame < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :iframe)
    end
  end
end