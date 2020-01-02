# frozen_string_literal: true

require_relative 'resizer'

module Crimson
  class RightResizer < Resizer
    def initialize
      super('ew-resize')

      style.width = '5px'
      style.height = '100%'
      style.position = 'absolute'
      style.top = 0
      style.right = 0
    end

    def on_mousemove(data)
      parent.style.width = "#{data.clientX - parent.style.left.delete_suffix('px').to_i - data.movementX}px"
      parent.commit!
    end
  end
end
