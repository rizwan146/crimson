require_relative '../object'

module Crimson
  class ListItem < Widget
    attr_reader :widget

    def initialize(widget, parent: app.root)
      super(parent: parent, tag: 'li')
      widget.bond(self)

      @widget = widget
    end
  end

  class List < Widget
    def initialize(*widgets, parent: app.root)
      super(parent: parent, tag: 'ul')
      widgets.each { |widget| append(widget) }
    end

    def empty?
      children.empty?
    end

    def first
      children.first.widget
    end

    def last
      children.last.widget
    end

    def [](index)
      children[index].widget
    end

    def append(widget)
      ListItem.new(widget, parent: self)
    end

    def delete(widget)
      item = widget.parent
      item.unbond
    end
  end
end