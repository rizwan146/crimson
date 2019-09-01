# frozen_string_literal: true

require_relative 'base'
require_relative 'object'
require_relative 'creater'
require_relative 'updater'
require_relative 'destroyer'

module Crimson
  class Object
    attr_reader :id
    @@id_count = 1

    def initialize
      @id = "crimson-#{app.name}-#{@@id_count}"
      @@id_count += 1

      creater.create(self)
    end

    def destroy
      destroyer.destroy(self)
    end

    def to_msg
      {
        id: id
      }
    end

    def ==(object)
      raise TypeError unless object.is_a?(self.class)

      id == object.id
    end

    def app
      Crimson::Application.instance
    end

    def creater
      app.creater
    end

    def updater
      app.updater
    end

    def destroyer
      app.destroyer
    end
  end

  class Widget < Object
    attr_reader :children, :parent

    def initialize(parent: app.root, tag: 'div')
      super()

      @parent = parent
      @parent&.add_child(self)

      @tag = tag
      @children = {}
    end

    def add_child(child)
      @children[child.id] = child
    end

    def remove_child(child)
      @children.delete(child.id)
    end

    def destroy
      @parent&.remove_child(self)
      @children.each_value(&:destroy)
      @children.clear
      super
    end

    def to_msg
      msg = super.merge(tag: @tag, children: @children.values.map(&:to_msg))
      msg.merge!(parent: @parent.id) if @parent
      msg
    end
  end

  class Data < Object
    attr_reader :value

    def initialize(parent: app.root, value: '')
      super()

      @parent = parent
      @parent&.add_child(self)

      @tag = 'div'
      @value = value
    end

    def to_msg
      msg = super.merge(tag: @tag, value: @value)
      msg.merge!(parent: @parent.id) if @parent
      msg
    end

    def destroy
      super
    end
  end
end
