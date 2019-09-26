# frozen_string_literal: true

require_relative 'publisher'
require_relative 'base'
require_relative 'object'

module Crimson
  class Object
    include Crimson::Publisher

    public

    attr_accessor :parent

    attr_reader :id, :tag, :attributes, :style

    protected

    attr_reader :channel, :subscribers, :events, :meta

    @@id_count = 1

    public

    def initialize(parent: app.root, tag: 'div')
      @id = :"crimson_#{app.name}_#{@@id_count}"
      @@id_count += 1
      app.objects[id] = self

      @channel = EventMachine::Channel.new
      @subscribers = {}

      @events = {}
      @meta = []

      @style = {}
      @attributes = {:class => [self.class.name]}
      @tag = tag

      bond(parent)
    end

    def emit(configuration, object: self)
      configuration = object.send(configuration) if configuration.is_a?(Symbol)
      channel << [object, configuration]
    end

    def create
      configuration.merge(action: :create)
    end

    def update(changes)
      changes.merge(action: :update, id: id)
    end

    def invoke(method, args)
      {
        action: :invoke,
        id: id,
        method: method,
        args: args
      }
    end

    def bond(parent)
      unbond

      self.parent = parent
      if parent && parent != app.root
        parent.add_child(self)
        parent.emit :create, object: self
      end
    end

    def unbond
      old_parent = self.parent
      self.parent = nil

      if old_parent
        old_parent.remove_child(self)
        old_parent.emit :destroy, object: self
      end
    end

    def destroy
      configuration.merge(action: :destroy)
    end

    def handle(event, *args)
      events[event].call(*args)
    end

    def on(*events, &on_event)
      events.each { |event| @events[event] = on_event }

      emit update(events: @events.keys)
    end

    def un(*events)
      events.each { |event| @events.delete(event) }

      emit update(events: @events.keys)
    end

    def set(attribute, value)
      attributes[attribute] = value
      emit update(attributes: attributes)
    end

    def get(attribute)
      attributes[attribute]
    end

    def style=(style = {})
      @style.merge!(style)
      emit update(style: style)
    end

    def css_class()
      return @attributes[:class]
    end

    def css_class=(css_class = [])

      class_attr = { class: css_class }
      @attributes.merge!(class_attr);
      emit update(attributes: class_attr)

    end

    def configuration
      configuration = {
        id: id,
        tag: tag,
        attributes: attributes,
        style: style,
        meta: meta,
        events: events.keys
      }
      configuration.merge!(parent: parent.id) if parent
      configuration
    end

    def method_missing(name, *args, &block)
      begin
        klass = Crimson.const_get("#{name}")
        instance = klass.new(*args, parent: self)
        instance.instance_eval(&block) if block
        return instance
      rescue NameError
        super(name, *args, &block)
      end
    end

    def to_s
      id.to_s
    end

    def ==(object)
      object.is_a?(self.class) && id == object.id
    end

    def app
      Crimson::Application.instance
    end
  end

  class Widget < Object
    attr_reader :children

    def initialize(parent: app.root, tag: 'div')
      @children = []
      super(parent: parent, tag: tag)
    end

    def add_subscriber(subscriber, on_publish)
      super(subscriber, on_publish)
      children.each { |child| child.add_subscriber(subscriber, on_publish) }
    end

    def remove_subscriber(subscriber)
      children.each { |child| child.remove_subscriber(subscriber) }
      super(subscriber)
    end

    def add_child(child)
      return if children.include?(child)

      children << child
    end

    def remove_child(child)
      return unless children.include?(child)
      
      children.delete(child)
    end

    def insert_child(index, child)
      add_child(child)

      # move the child to the proper index
      emit invoke('insertBefore', [child.id, children[index].id])
      
      # also swap the children in the children array
      children.delete(child)
      children.insert(index, child)
    end

    def configuration
      super.merge(children: @children.map(&:configuration))
    end
  end

  class Data < Object
    attr_reader :value

    def initialize(parent: app.root, value: '', tag: 'div')
      @value = value
      super(parent: parent, tag: tag)
    end

    def configuration
      super.merge(value: @value)
    end

    def value=(val)
      @value = val
      emit update(value: value)
    end
  end
end
