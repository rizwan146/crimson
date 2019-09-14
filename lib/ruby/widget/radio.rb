require_relative '../object'

module Crimson
  class Radio < Widget
    def initialize(checked: false, parent: app.root)
      super(parent: parent, tag: 'input')

      attributes.merge!(type: "radio", checked: checked)
      emit update(attributes: attributes)
    end

    def checked?
      attributes[:checked]
    end

    def unchecked?
      !checked?
    end

    def check
      attributes[:checked] = true
      emit update(attributes: attributes)
    end

    def uncheck
      attributes[:checked] = false
      emit update(attributes: attributes)
    end
  end
end