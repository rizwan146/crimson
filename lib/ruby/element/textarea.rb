require_relative 'base'

module Crimson
  module Element
    class TextArea < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :textarea)
        
        attributes.merge!(value: "", placeholder: "", rows: 1, cols: 20)
        meta.push(:value)
        update(meta: meta, attributes: attributes)
      end
    end
  end
end