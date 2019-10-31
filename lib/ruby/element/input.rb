require_relative 'base'

module Crimson
    module Element
      class Input  < Base
        def initialize(type, parent: app.root)
          super(parent: parent, tag: :input)
  
          set :type, type
          meta.push :value
        end
      end
    end
  end