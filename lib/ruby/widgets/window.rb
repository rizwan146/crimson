# frozen_string_literal: true

require 'hashie'
require_relative '../object'
require_relative 'titlebar'

module Crimson
  class Window < Crimson::Object
    attr_reader :offset, :titlebar

    def initialize(title, width = "800px", height = "600px")
      super(:div)

      @offset = Hashie::Mash.new
      @titlebar = Titlebar.new(title)
      add(titlebar)

      self.style = {
        "left": "0px",
        "top": "0px",
        "height": height,
        "width": width,
        "position": "absolute",
        "background-color": "white",
        "border-radius": "10px",
        "box-shadow": "0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)",
      }
      self.draggable = true

      on("dragstart", &method(:on_dragstart))
    end

    def on_dragstart(data)
      offset.top = style.top.delete_suffix("px").to_i - data.clientY
      offset.left = style.left.delete_suffix("px").to_i - data.clientX
    end
  end
end
