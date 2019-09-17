# frozen_string_literal: true

module Crimson
  module Themeable
    def theme(*themes)
      style = {}
      themes.each do |theme|
        theme = Crimson.const_get( theme.to_s.split('_').collect(&:capitalize).join ).new
        style.merge!(theme.style)
      end
      style
    end
  end

  class Theme
    include Themeable

    def style
      {

      }
    end
  end
end
