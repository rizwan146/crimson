require_relative '../object'
require_relative 'text'

module Crimson
  class Button < Widget
    attr_reader :text
    
    def initialize(text = "", parent: app.root)
      super(parent: parent, tag: 'button')
      @text = Text.new(text, parent: self)
    end

    def text=(value)
      @text.value = value
    end
  end
end