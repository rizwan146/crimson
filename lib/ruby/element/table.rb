# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Element
    class Table < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :table)
      end
    end

    class TableData < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :td)
      end
    end

    class TableHeader < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :th)
      end
    end

    class TableRow < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :tr)
      end
    end

    class TableHead < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :thead)
      end
    end

    class TableBody < Base
      def initialize(parent: app.root)
        super(parent: parent, tag: :tbody)
      end
    end
  end
end
