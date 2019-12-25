# frozen_string_literal: true

require_relative 'element'

module Crimson
  class ElementPool
    protected

    attr_reader :pool

    public

    def initialize
      super if defined?(super)

      @pool = {}
    end

    def add(element)
      raise ArgumentError unless element.is_a?(Element)

      id = generate_element_id
      element[:id] = id
      pool[id] = element
    end

    def remove(element)
      raise ArgumentError unless element.is_a?(Element)

      pool.delete(element[:id])
    end
  end
end
