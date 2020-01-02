# frozen_string_literal: true

require_relative 'resizer'

module Crimson
  class BottomResizer < Resizer
    def initialize
      super('ns-resize')

      style.width = '100%'
      style.height = '5px'
      style.position = 'absolute'
      style.bottom = 0
      style.left = 0
    end

    def on_mousemove(data)
        parent.style.height = "#{data.clientY - parent.style.top.delete_suffix('px').to_i - data.movementY}px"
        parent.commit!
    end
  end
end
