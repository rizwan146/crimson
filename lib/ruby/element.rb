# frozen_string_literal: true

require_relative 'model'
require_relative 'node'

module Crimson
  class Element
    include Model
    include Node

    attr_reader :id, :tag

    def initialize(opts = {})
      super()

      @id = opts[:id]
      @tag = opts[:tag] || :div

      local.merge!(opts[:attributes] || {})
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

    def attributes=(attributes = {})
      local.merge!(attributes)
    end

    def to_json(*_args)
      {
        id: id,
        tag: tag,
        attributes: attributes,
        children: children.map(:id),
        parent: parent.id
      }
    end
  end
end
