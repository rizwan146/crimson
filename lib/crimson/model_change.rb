# frozen_string_literal: true

module Crimson
  class ModelChange
    attr_reader :old_value, :new_value

    def initialize(old_value, new_value)
      @old_value = old_value
      @new_value = new_value
    end

    def inspect
      to_s
    end

    def to_s
      return "<#{old_value.inspect}, #{new_value.inspect}>"
    end
  end
end