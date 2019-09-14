require_relative '../object'

module Crimson
  class Image < Widget
    attr_reader :src

    def initialize(source, parent: app.root)
      super(parent: parent, tag: 'img')
      self.src = source
    end

    def src=(source)
      @src = source
      attributes.merge!(src: source)
      emit update(attributes: attributes)
    end
  end
end