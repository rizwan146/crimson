# frozen_string_literal: true

require_relative '../object'

module Crimson
  class Form < Crimson::Object
    def initialize
      super(:form)
      self.onsubmit = "return false"
    end
  end
end
