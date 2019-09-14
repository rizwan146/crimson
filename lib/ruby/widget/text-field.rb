require_relative '../object'

module Crimson
  class TextField < Widget
    def initialize(value: '', rows: 1, cols: 20, placeholder: '', parent: app.root)
      super(parent: parent, tag: 'textarea')
      
      attributes.merge!(
        value: value,
        rows: rows,
        cols: cols,
        placeholder: placeholder
      )

      meta.push("value")
      
      emit update(attributes: attributes, meta: meta)
    end

    def value
      attributes[:value]
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