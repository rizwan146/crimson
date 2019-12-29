require_relative '../object'

module Crimson
  class Titlebar < Crimson::Object
    attr_reader :title, :hide, :resize, :close

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

      @hide = Object.new(:img)
      hide.src = "./icons/hide.png"
      hide.style = {
        "background-color": "rgba(0, 0, 0, 0.0)",
        "padding": "10px 20px"
      }
      hide.on("mouseenter") do |data|
        hide.style.backgroundColor = "rgba(0, 0, 0, 0.6)";
        hide.commit!
      end
      hide.on("mouseleave") do |data|
        hide.style.backgroundColor = "rgba(0, 0, 0, 0.0)";
        hide.commit!
      end
      add(hide)

      @resize = Object.new(:img)
      resize.src = "./icons/resize.png"
      resize.style = {
        "padding": "8px 16px"
      }
      resize.on("mouseenter") do |data|
        resize.style.backgroundColor = "rgba(0, 0, 0, 0.6)";
        resize.commit!
      end
      resize.on("mouseleave") do |data|
        resize.style.backgroundColor = "rgba(0, 0, 0, 0.0)";
        resize.commit!
      end
      add(resize)

      @close = Object.new(:img)
      close.src = "./icons/close.png"
      close.style = {
        "border-radius": "0 10px 0 0",
        "padding": "10px 20px"
      }
      close.on("mouseenter") do |data|
        close.style.backgroundColor = "rgba(0, 0, 0, 0.6)";
        close.commit!
      end
      close.on("mouseleave") do |data|
        close.style.backgroundColor = "rgba(0, 0, 0, 0.0)";
        close.commit!
      end
      add(close)

      self.style = {
        "border-radius": "10px 10px 0 0",
        "background-color": "#2ecc71",
        "width": "100%",
        "height": "35px",
        "display": "flex",
      }
    end

    def title=(window_title)
      title.innerHTML = window_title
    end
  end
end