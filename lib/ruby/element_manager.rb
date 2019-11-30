# frozen_string_literal: true

require_relative 'element'

module Crimson
  module ElementManager
    protected

    attr_reader :elements

    public

    def initialize
      super if defined?(super)

      @elements = {}
    end

    def [](id)
      elements[id]
    end

    def create(tag)
      id = generate_element_id

      element = Element.new(id: id, tag: tag)
      element.add_observer(self)
      elements[id] = element

      element
    end

    def destroy(id)
      elements.delete(id)
    end

    def on_commit(changes); end

    def generate_element_id
      "crimson_#{elements.keys.size}"
    end
  end
end
