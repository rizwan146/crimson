require_relative '../object'

module Crimson
  class Input < Crimson::Object
    def initialize(type)
      super(:input)
      self.type = type
    end
  end
end