require_relative '../object'

module Crimson
  class Titlebar < Crimson::Object
    attr_reader :title, :hide_button, :resize_button, :close_button

    def initialize(window_title)
      super(:div)

      @title = Object.new(:div)
      self.title = window_title
      title.style = {
        "color": "white",
        "font-family": "Verdana",
        "font-weight": "bold",
        "text-align": "center",
        "margin": "auto",
      }
      add(title)

      @hide_button = Object.new(:img)
      hide_button.src = "./icons/hide.png"
      hide_button.style = {
        "background-color": "rgba(0, 0, 0, 0.0)",
        "padding": "10px 20px",
      }
      hide_button.on("mouseenter") do |data|
        hide_button.style.backgroundColor = "rgba(0, 0, 0, 0.6)"
        hide_button.commit!
      end
      hide_button.on("mouseleave") do |data|
        hide_button.style.backgroundColor = "rgba(0, 0, 0, 0.0)"
        hide_button.commit!
      end
      add(hide_button)

      @resize_button = Object.new(:img)
      resize_button.src = "./icons/resize.png"
      resize_button.style = {
        "padding": "8px 16px",
      }
      resize_button.on("mouseenter") do |data|
        resize_button.style.backgroundColor = "rgba(0, 0, 0, 0.6)"
        resize_button.commit!
      end
      resize_button.on("mouseleave") do |data|
        resize_button.style.backgroundColor = "rgba(0, 0, 0, 0.0)"
        resize_button.commit!
      end
      add(resize_button)

      @close_button = Object.new(:img)
      close_button.src = "./icons/close.png"
      close_button.style = {
        "padding": "10px 20px",
      }
      close_button.on("mouseenter") do |data|
        close_button.style.backgroundColor = "rgba(0, 0, 0, 0.6)"
        close_button.commit!
      end
      close_button.on("mouseleave") do |data|
        close_button.style.backgroundColor = "rgba(0, 0, 0, 0.0)"
        close_button.commit!
      end
      add(close_button)

      self.style = {
        "background-color": "#2ecc71",
        "width": "100%",
        "height": "35px",
        "display": "flex",
        "user-select": "none",
      }
    end

    def title=(window_title)
      title.innerHTML = window_title
    end

    def buttons
      [hide_button, resize_button, close_button]
    end
  end
end