# frozen_string_literal: true

module Crimson
  module Node
    attr_reader :parent, :children

    def initialize
      super if defined?(super)

      @parent = nil
      @children = []
    end
  end
end
