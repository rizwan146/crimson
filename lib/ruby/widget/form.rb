require_relative '../object'

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

      set :type, type
      meta.push :value
    end
  end
end