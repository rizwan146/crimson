# frozen_string_literal: true

require_relative 'resizer'

module Crimson
  class LeftResizer < Resizer
    def initialize
      super('ew-resize')

      style.width = '5px'
      style.height = '100%'
      style.position = 'absolute'
      style.top = 0
      style.left = 0
    end

    def on_mousemove(data)
      min_width = parent.style.minWidth.delete_suffix('px').to_i
      new_width = parent.style.width.delete_suffix('px').to_i - data.movementX
      new_left = parent.style.left.delete_suffix('px').to_i + data.movementX

      parent.style.width = "#{new_width}px"
      parent.style.left = "#{new_left}px" unless new_width < min_width
      parent.commit!
    end
  end
end
