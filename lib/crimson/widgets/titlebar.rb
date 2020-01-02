# frozen_string_literal: true

require_relative '../object'

module Crimson
  class Titlebar < Crimson::Object
    attr_reader :title, :hide_button, :resize_button, :close_button

    def initialize(window_title)
      super(:div)

      @title = Object.new(:div)
      self.title = window_title
      title.style.color = 'white'
      title.style.fontFamily = 'Verdana'
      title.style.fontWeight = 'bold'
      title.style.textAlign = 'center'
      title.style.margin = 'auto'
      add(title)

      @hide_button = Object.new(:img)
      hide_button.src = 'crimson/icons/hide.png'
      hide_button.style.padding = '10px 20px'
      hide_button.on('mouseenter') do |_data|
        hide_button.style.backgroundColor = 'rgba(0, 0, 0, 0.6)'
        hide_button.commit!
      end
      hide_button.on('mouseleave') do |_data|
        hide_button.style.backgroundColor = 'rgba(0, 0, 0, 0.0)'
        hide_button.commit!
      end
      add(hide_button)

      @resize_button = Object.new(:img)
      resize_button.src = 'crimson/icons/resize.png'
      resize_button.style.padding = '8px 16px'
      resize_button.on('mouseenter') do |_data|
        resize_button.style.backgroundColor = 'rgba(0, 0, 0, 0.6)'
        resize_button.commit!
      end
      resize_button.on('mouseleave') do |_data|
        resize_button.style.backgroundColor = 'rgba(0, 0, 0, 0.0)'
        resize_button.commit!
      end
      add(resize_button)

      @close_button = Object.new(:img)
      close_button.src = 'crimson/icons/close.png'
      close_button.style.padding = '10px 20px'
      close_button.on('mouseenter') do |_data|
        close_button.style.backgroundColor = 'rgba(0, 0, 0, 0.6)'
        close_button.commit!
      end
      close_button.on('mouseleave') do |_data|
        close_button.style.backgroundColor = 'rgba(0, 0, 0, 0.0)'
        close_button.commit!
      end
      add(close_button)

      style.backgroundColor = '#2ecc71'
      style.width = '100%'
      style.height = '35px'
      style.display = 'flex'
      style.userSelect = 'none'
    end

    def title=(window_title)
      title.innerHTML = window_title
    end

    def buttons
      [hide_button, resize_button, close_button]
    end
  end
end
