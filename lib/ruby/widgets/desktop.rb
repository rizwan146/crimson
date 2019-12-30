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

      on('drop', &method(:on_drop))
    end

    def on_drop(data)
      object = node[data.target.to_sym].content
      object.style.left = "#{data.clientX + object.offset.left}px"
      object.style.top = "#{data.clientY + object.offset.top}px"
      object.commit!
    end

    def create_window(*args)
      window = Crimson::Window.new(*args)
      add(window)

      window.titlebar.close_button.on('click') do |_data|
        remove(window)
        commit_tree!
      end

      window.titlebar.resize_button.on('click') do |_data|
        if window.maximized?
          window.minimize
        else
          window.maximize
        end
        window.commit!
      end

      window
    end
  end
end
