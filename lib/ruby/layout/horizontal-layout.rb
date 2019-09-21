require_relative '../object'

module Crimson
  class HorizontalLayout < Widget
    def initialize(objects = [], parent: app.root)
        super(parent: parent)

        self.style = {
            'display': 'flex',
            'flex-direction': 'row',
            'justify-content': 'space-evenly',
            'align-items': 'vertically',
            'align-content': 'space-evenly'
        }

        objects.each do |object|
          object.style = { 'flex': '1 1 auto' }
          object.bond(self)
        end
    end
  end
end