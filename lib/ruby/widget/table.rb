# frozen_string_literal: true

require_relative '../object'
require_relative 'text'

module Crimson
  class Column < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :td)
    end
  end

  class ColumnHead < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :th)
    end
  end

  class Row < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :tr)
    end
  end

  class Table < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :table)
    end
  end

  class THead < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :thead)
    end
  end

  class TBody < Widget
    def initialize(parent: app.root)
      super(parent: parent, tag: :tbody)
    end
  end
end
