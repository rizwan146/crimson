# frozen_string_literal: true

require_relative 'resizer'

module Crimson
  class TopResizer < Resizer
    def initialize
      super('ns-resize')

      style.width = '100%'
      style.height = '5px'
      style.position = 'absolute'
      style.top = 0
      style.left = 0
    end

    def on_mousemove(data)
      min_height = parent.style.minHeight.delete_suffix('px').to_i
      new_height = parent.style.height.delete_suffix('px').to_i - data.movementY
      new_top = parent.style.top.delete_suffix('px').to_i + data.movementY

      parent.style.height = "#{new_height}px"
      parent.style.top = "#{new_top}px" unless new_height < min_height
      parent.commit!
    end
  end
end
