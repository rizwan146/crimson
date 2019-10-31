require_relative 'base'

module Crimson
  module Element
    class Form < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :form)

        # this prevent the page from refreshing when we submit the form
        set :onsubmit, :'return false'
      end
    end
  end
end