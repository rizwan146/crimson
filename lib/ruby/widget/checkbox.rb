
require_relative '../object'

module Crimson
  class Checkbox < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: 'input')

      attributes.merge!(type: "checkbox")
      update(attributes: attributes)
    end

    def checked?
      attributes[:checked]
    end

    def unchecked?
      !checked?
    end

    def toggle
      attributes[:checked] = !attributes[:checked]
      update(attributes: attributes)
    end

    def check
      attributes[:checked] = true
      update(attributes: attributes)
    end

    def uncheck
      attributes[:checked] = false
      update(attributes: attributes)
    end
  end
end