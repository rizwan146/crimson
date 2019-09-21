require_relative '../object'

module Crimson
  class Label < Data
    def initialize(text, parent: app.root)
      super(parent: parent, tag: :label)
      self.value = text
    end
  end
end