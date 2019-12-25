# frozen_string_literal: true

require_relative 'html'
require_relative 'model'

module Crimson
  class Element
    protected

    include Html

    public

    include Model

    def initialize(opts = {})
      super()

      local.merge!(opts)
    end

    def [](attribute)
      local[attribute]
    end

    def []=(attribute, value)
      if value.nil?
        local.delete(attribute)
      else
        local[attribute] = value
      end
    end

    def set(attributes = {})
      local.merge!(attributes)
      local.compact!
    end

    def minimal
      { id: master[:id] }
    end
  end
end
