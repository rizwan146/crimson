# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Element
    class Select < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :select)
        
        meta.push("value")
        update(meta: meta)
      end
    end
  end
end
