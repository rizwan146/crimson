require_relative 'base'

module Crimson
  module Element
    class Label < Base
      def initialize(text, parent: app.root)
        super(parent: parent, tag: :label)
        set :value, text
      end
    end
  end
end