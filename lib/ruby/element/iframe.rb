require_relative 'base'

module Crimson
  module Element
    class IFrame < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :iframe)
      end
    end
  end
end