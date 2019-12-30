# frozen_string_literal: true

require_relative '../object'

module Crimson
  class Resizer < Crimson::Object
    attr_reader :cursor

    def initialize(cursor)
      super(:div)

      @cursor = cursor
      self.style = {}

      enable
    end

    def enable
      style.cursor = cursor
      on(:mousedown, method(:on_mousedown))
      commit!
    end

    def disable
      style.cursor = "auto"
      un(:mousedown, method(:on_mousedown))
      commit!
    end

    def on_mousedown(_data)
      parent.parent.on(:mousemove, method(:on_mousemove))
      parent.parent.on(:mouseup, method(:on_mouseup))
    end

    def on_mouseup(_data)
      parent.parent.un(:mousemove, method(:on_mousemove))
      parent.parent.un(:mouseup, method(:on_mouseup))
    end
  end
end
