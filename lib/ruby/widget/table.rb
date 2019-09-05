require_relative '../object'

module Crimson
  class Table < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: 'table')
    end
  end
end