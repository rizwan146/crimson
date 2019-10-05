require_relative '../object'
require_relative '../variable'

module Crimson
  class Form < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :form)

      # this prevent the page from refreshing when we submit the form
      set :onsubmit, :'return false'
    end
  end

  class Input  < Widget
    def initialize(type, parent: app.root)
      super(parent: parent, tag: :input)
      @value = Var.new("")

      set :type, type
      meta.push :value

      on(:keyup) do |meta|
        @value.set( meta[:value] )
      end
    end

    def value
      return @value.get
    end
  end
end