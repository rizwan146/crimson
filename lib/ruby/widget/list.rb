require_relative '../object'

module Crimson
  class ListItem < Widget
    def initialize(parent, widget)
      super(parent: parent, tag: 'li')
      widget.parent = self
    end
  end

  class List < Widget
    def initialize(*widgets, parent: app.root)
      super(parent: parent, tag: 'ul')
      @items = []
      @list_items = {}
      widgets.each { |widget| append widget }
    end

    def empty?
      @items.empty?
    end

    def first
      app.objects[@items.first]
    end

    def last
      app.objects[@items.last]
    end

    def [](index)
      app.objects[@items[index]]
    end

    def append(widget)
      item = ListItem.new(self, widget)
      @items << widget.id
      @list_items[widget.id] = item
    end

    def delete(widget)
      item = @list_items[widget.id]
      remove_child item
      @items.delete(widget.id)
      item.destroy
    end
  end
end