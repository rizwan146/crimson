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
      
      updater.update(id, attributes: attributes, meta: meta)
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
      updater.update(id, attributes: attributes)
    end

    def rows=(val)
      attributes[:rows] = val
      updater.update(id, attributes: attributes)
    end

    def cols=(val)
      attributes[:cols] = val
      updater.update(id, attributes: attributes)
    end
  end
end