require_relative '../object.rb'

module Crimson
  class H1 < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value, tag: 'h1')
    end
  end

  class H2 < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value, tag: 'h2')
    end
  end

  class H3 < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value, tag: 'h3')
    end
  end

  class H4 < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value, tag: 'h4')
    end
  end

  class H5 < Data
    def initialize(value = "", parent: app.root)
      super(parent: parent, value: value, tag: 'h5')
    end
  end
end