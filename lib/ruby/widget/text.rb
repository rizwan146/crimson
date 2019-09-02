require_relative '../object.rb'

module Crimson
  class Text < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value)
    end
  end
end