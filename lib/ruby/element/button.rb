require_relative 'base'

module Crimson
  module Element
    class Button < Base
      attr_reader :text
      
      def initialize(text = "", parent: app.root)
        super(parent: parent, tag: 'button')
        set :value, text
      end
    end
  end
end