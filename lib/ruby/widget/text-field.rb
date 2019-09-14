require_relative '../object'

module Crimson
  class TextField < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: 'textarea')
      
      attributes.merge!(value: "", placeholder: "", rows: 1, cols: 20)
      meta.push("value")
      emit update(meta: meta, attributes: attributes)
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
      emit update(attributes: attributes)
    end

    def placeholder=(text)
      attributes[:placeholder] = text
      emit update(attributes: attributes)
    end

    def rows=(val)
      attributes[:rows] = val
      emit update(attributes: attributes)
    end

    def cols=(val)
      attributes[:cols] = val
      emit update(attributes: attributes)
    end
  end
end