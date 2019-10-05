require_relative '../object'

module Crimson
  class TextField < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :textarea)
      
      attributes.merge!(value: "", placeholder: "", rows: 1, cols: 20)
      meta.push(:value)
      update(meta: meta, attributes: attributes)
    end

    def value
      attributes[:value]
    end

    def placeholder
      attributes[:placeholder]
    end

    def rows
      attributes[:rows]
    end

    def cols
      attributes[:cols]
    end

    def value=(text)
      attributes[:value] = text
      update(attributes: attributes)
    end

    def placeholder=(text)
      attributes[:placeholder] = text
      update(attributes: attributes)
    end

    def rows=(val)
      attributes[:rows] = val
      update(attributes: attributes)
    end

    def cols=(val)
      attributes[:cols] = val
      update(attributes: attributes)
    end
  end

  class TextArea < TextField
  end
end