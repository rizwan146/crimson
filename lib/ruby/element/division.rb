require_relative 'base'

module Crimson
  module Element
    class Division < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :div)
      end
    end
  end
end