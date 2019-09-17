require_relative '../object'

module Crimson
  class VerticalLayout < Widget
    def initialize(objects = [], parent: app.root)
        super(parent: parent)

        self.style = {
            'display': 'flex',
            'flex-direction': 'column',
            'justify-content': 'space-equal',
            'align-items': 'horizontally',
            'align-content': 'stretch'
        }

        objects.each do |object|
          object.style = { 'flex': '1 1 auto' }
          object.bond(self)
        end
    end
  end
end