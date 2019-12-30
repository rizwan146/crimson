# frozen_string_literal: true

require 'hashie'
require_relative '../object'
require_relative 'titlebar'

module Crimson
  class Window < Crimson::Object
    attr_reader :offset, :titlebar, :previous_dimensions

    def initialize(title, width = "800px", height = "600px")
      super(:div)

      @offset = Hashie::Mash.new
      @previous_dimensions = Hashie::Mash.new
      @titlebar = Titlebar.new(title)
      add(titlebar)

      self.style = {
        "left": "0px",
        "top": "0px",
        "height": height,
        "width": width,
        "min-height": "200px",
        "min-width": "400px",
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

    def maximized?
      style.height == "100vh" && style.width == "100vw"
    end

    def minimized?
      !maximized?
    end

    def maximize
      previous_dimensions.top = style.top.dup
      previous_dimensions.left = style.left.dup
      previous_dimensions.width = style.width.dup
      previous_dimensions.height = style.height.dup

      style.top = "0px"
      style.left = "0px"
      style.width = "100vw"
      style.height = "100vh"
    end

    def minimize
      style.top = previous_dimensions.top.dup
      style.left =  previous_dimensions.left.dup
      style.width = previous_dimensions.width.dup
      style.height =  previous_dimensions.height.dup
    end
  end
end
