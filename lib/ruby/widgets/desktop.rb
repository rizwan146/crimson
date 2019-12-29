# frozen_string_literal: true

require_relative '../object'

module Crimson
  class Desktop < Crimson::Object
    def initialize
      super(:div)

      self.style = {
        "height": "100vh",
        "width": "100vw",
        "max-height": "100vh",
        "max-width": "100vw",
        "overflow": "hidden",
        "position": "fixed",
        "left": 0,
        "top": 0
      }

      self.ondragover = "event.preventDefault();"
      self.ondrop = "event.preventDefault();"

      on("drop", &method(:on_drop))
    end

    def on_drop(data)
      object = node[data.target.to_sym].content
      object.style.left = "#{data.clientX + object.offset.left}px"
      object.style.top = "#{data.clientY + object.offset.top}px"
      object.commit!
    end
  end
end
