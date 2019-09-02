# frozen_string_literal: true

require 'wisper'
require_relative 'base'
require_relative 'object'

module Crimson
  class Object
    include Wisper::Publisher

    attr_reader :id, :parent, :tag, :attributes, :style, :events
    @@id_count = 1

    def initialize(parent: app.root, tag: 'div')
      @id = "crimson-#{app.name}-#{@@id_count}"
      @@id_count += 1
      @events = []
      @style = {}
      @attributes = {}
      @tag = tag
      @parent = parent
      @parent&.add_child(self)
      creator.create(self)
    end

    def destroy
      destroyer.destroy(self)
    end

    def on(*events, &block)
      @events |= events
      updater.update(id, events: @events.map(&:to_s))

      super(*events, &block)
    end

    def subscribe(listener, options = {})
      @events |= if options.key?(:on)
                   options[:on]
                 else
                   listener.public_instance_methods(false)
                 end
      updater.update(id, events: @events.map(&:to_s))

      super(listener, options)
    end

    def notify(event, meta)
      broadcast(event, meta)
    end

    def to_msg
      msg = {
        id: id,
        tag: tag,
        attributes: attributes,
        style: style,
        events: events.map(&:to_s)
      }
      msg.merge!(parent: parent.id) if parent
      msg
    end

    def ==(object)
      raise TypeError unless object.is_a?(self.class)

      id == object.id
    end

    def app
      Crimson::Application.instance
    end

    def creator
      app.creator
    end

    def updater
      app.updater
    end

    def destroyer
      app.destroyer
    end

    def notifier
      app.notifier
    end
  end

  class Widget < Object
    attr_reader :children

    def initialize(parent: app.root, tag: 'div')
      @children = {}
      super(parent: parent, tag: tag)
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
      super.merge(children: @children.values.map(&:to_msg))
    end
  end

  class Data < Object
    attr_reader :value

    def initialize(parent: app.root, value: '')
      @value = value
      super(parent: parent)
    end

    def to_msg
      super.merge(value: @value)
    end

    def destroy
      super
    end

    def value=(val)
      @value = val
      updater.update(id, value: value)
    end
  end
end
