require_relative '../object'

module Crimson
  class Radio < Widget
    def initialize(checked: false, parent: app.root)
      super(parent: parent, tag: 'input')

      attributes.merge!(type: "radio", checked: checked)
      updater.update(id, attributes: attributes)
    end

    def checked?
      attributes[:checked]
    end

    def unchecked?
      !checked?
    end

    def check
      attributes[:checked] = true
      updater.update(id, attributes: attributes)
    end

    def uncheck
      attributes[:checked] = false
      updater.update(id, attributes: attributes)
    end
  end
end