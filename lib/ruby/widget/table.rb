# frozen_string_literal: true

require_relative '../object'
require_relative 'text'

module Crimson
  class TableColumn < Widget
    attr_reader :widget

    def initialize(parent, widget)
      super(parent: parent, tag: 'td')
      self.widget = widget
    end

    def widget=(widget)
      if widget.is_a?(String)
        widget = Crimson::Text.new widget, parent: self
      else
        widget.parent = self
      end

      @widget = widget
    end
  end

  class TableRow < Widget
    attr_reader :columns

    def initialize(parent, columns)
      super(parent: parent, tag: 'tr')
      @columns = []
      columns.each { |column| append column }
    end

    def insert(index, column)
      raise IndexError unless columns[index]

      column_widget = TableColumn.new(self, column)
      invoker.invoke(
        id,
        "insertBefore",
        [ column_widget.id, columns[index].id ]
      )
      columns.insert(index, column_widget)

      column_widget
    end

    def append(column)
      column_widget = TableColumn.new(self, column)
      columns << column_widget
      column_widget
    end

    def delete(column)
      remove_child column
      columns.delete(column)
      column.destroy
    end

    def [](index)
      raise IndexError unless columns[index]

      columns[index]
    end

    def []=(index, widget)
      raise IndexError unless columns[index]

      columns[index].widget = widget
    end
  end

  class Table < Widget
    attr_reader :rows

    def initialize(*rows, parent: app.root)
      super(parent: parent, tag: 'table')
      @rows = []
      rows.each { |row| append row }
    end

    def insert(index, row)
      raise IndexError unless rows[index]

      row_widget = TableRow.new(self, row)
      invoker.invoke(
        id,
        "insertBefore",
        [ row_widget.id, rows[index].id ]
      )
      rows.insert(index, row_widget)

      row_widget
    end

    def append(row)
      row_widget = TableRow.new(self, row)
      rows << row_widget
      row_widget
    end

    def delete(row_widget)
      remove_child row_widget
      rows.delete(row_widget)
      row_widget.destroy
    end

    def [](index)
      raise IndexError unless rows[index]

      rows[index]
    end
  end
end
