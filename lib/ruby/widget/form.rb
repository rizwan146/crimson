require_relative '../object'

module Crimson
  class Form < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :form)
    end
  end

  class Input  < Widget
    def initialize(type, parent: app.root)
      super(parent: parent, tag: :input)

      set :type, type
    end
  end
end