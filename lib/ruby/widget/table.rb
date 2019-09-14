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
    def initialize(parent, columns)
      super(parent: parent, tag: 'tr')
      columns.each { |column| append column }
    end

    def insert(index, column)
      raise IndexError unless columns[index]

      insert_child(index, TableColumn.new(self, column))
      columns[index]
    end

    def append(column)
      add_child(TableColumn.new(self, column))
      columns.last
    end

    def delete(column)
      remove_child(column)
    end

    def columns
      children
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
    def initialize(*rows, parent: app.root)
      super(parent: parent, tag: 'table')
      rows.each { |row| append row }
    end

    def insert(index, row)
      raise IndexError unless rows[index]

      insert_child(index, TableRow.new(self, row))
      rows[index]
    end

    def append(row)
      add_child(TableRow.new(self, row))
      rows.last
    end

    def delete(row_widget)
      remove_child(row_widget)
    end

    def rows
      children
    end

    def [](*args)
      row, col = *args
      raise IndexError unless rows[row]

      if col then return children[row][col] else return children[row] end
    end
  end
end
