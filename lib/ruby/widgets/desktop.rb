# frozen_string_literal: true

require_relative '../object'
require_relative 'window'

module Crimson
  class Desktop < Crimson::Object
    def initialize
      super(:div)

      self.style = {
        "height": '100vh',
        "width": '100vw',
        "max-height": '100vh',
        "max-width": '100vw',
        "overflow": 'hidden',
        "position": 'fixed',
        "left": "0px",
        "top": "0px"
      }

      self.ondragover = 'event.preventDefault();'
      self.ondrop = 'event.preventDefault();'

      on('drop', method(:on_drop))
    end

    def on_drop(data)
      window = find_descendant(data.target.to_sym).parent

      unless window.nil?
        window.style.left = "#{data.clientX + window.offset.left}px"
        window.style.top = "#{data.clientY + window.offset.top}px"
        window.commit!
      end
    end

    def create_window(*args)
      window = Crimson::Window.new(*args)
      add(window)
      window
    end
  end
end
