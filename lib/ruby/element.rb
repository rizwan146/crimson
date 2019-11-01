# frozen_string_literal: true

require 'docile'
require_relative 'application'
require_relative 'publisher'

module Crimson
  class Element
    include Crimson::Publisher

    protected

    attr_reader :channel, :subscribers, :events, :meta

    @@id_count = 1

    public

    attr_accessor :parent

    attr_reader :id, :tag, :attributes, :style, :children

    def initialize(parent: app.root, tag: 'div')
      @id = :"crimson_#{app.name}_#{@@id_count}"
      @@id_count += 1
      app.objects[id] = self

      @children = []
      
      @channel = EventMachine::Channel.new
      @subscribers = {}

      @events = {}
      @meta = [:value]

      @style = {}
      @attributes = {:class => [self.class.name]}
      @tag = tag

      bond(parent)
    end

    def update(changes)
      emit changes.merge(action: :update, id: id)
    end

    def invoke(invokable)
      if !invokable.key?(:method)
        raise(ArgumentError, "Expected invokable to include method name")
      elsif !invokable.key?(:args)
        raise(ArgumentError, "Expected invokable to include method args")
      end

      emit invoke_configuration.merge(invokable)
    end

    def create_configuration
      configuration.merge(action: :create)
    end

    def destroy_configuration
      { action: :destroy, id: id }
    end

    def invoke_configuration
      { action: :invoke, invoker: :default, id: id }
    end

    def bond(parent)
      unbond

      self.parent = parent
      if parent && parent != app.root
        parent.add_child(self)
        parent.each_subscriber { |client| client.create(self) }
      end
    end

    def unbond
      old_parent = self.parent
      self.parent = nil

      if old_parent
        old_parent.remove_child(self)
        old_parent.each_subscriber { |client| client.destroy(self) }
      end
    end

    def handle(event, *args)
      @events[event].each { |handler| handler.call(*args) }
    end

    def on(*events, &handler)
      events.each do |event|
        if @events[event]
          @events[event] << handler
        else
          @events[event] = [handler]
        end
      end

      update(events: @events.keys)
    end

    def un(*events_to_unlink, &handler)
      events_to_unlink.each do |event|
        if handler && @events[event]
          @events[event].delete(handler)
        elsif handler.nil? && @events[event]
          @events.delete(event)
        end
      end

      update(events: @events.keys)
    end

    def set(attribute, value)
      attributes[attribute] = value
      update(attributes: attributes)
    end

    def get(attribute)
      attributes[attribute]
    end

    def style=(style = {})
      @style.merge!(style)
      update(style: style)
    end

    def css_class()
      return @attributes[:class]
    end

    def css_class=(css_class = [])
      class_attr = { class: css_class }
      @attributes.merge!(class_attr);
      update(attributes: class_attr)
    end

    def configuration
      configuration = {
        id: id,
        tag: tag,
        attributes: attributes,
        style: style,
        meta: meta,
        events: events.keys,
        children: children.map(&:configuration)
      }
      configuration.merge!(parent: parent.id) if parent
      configuration
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

    def append(child)
      child.bond(self)
    end

    def remove(child)
      child.unbond if child.parent == self
    end

    def remove_all
      remove(children.first) until children.empty?
    end

    def insert(index, child)
      append(child)

      unless index == children.length
        # move the child to the proper index
        invoke(method: 'insertBefore', args: [child.id, children[index].id])
        
        # also swap the children in the children array
        children.delete(child)
        children.insert(index, child)
      end
    end

    def replace(index, child)
      remove(children[index])
      insert(index, child)
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
    
    [
      :button,
      :canvas,
      :div,
      :form,
      :h1,
      :h2,
      :h3,
      :h4,
      :h5,
      :h6,
      :iframe,
      :img,
      :input,
      :label,
      :ul,
      :ol,
      :li,
      :p,
      :select,
      :table,
      :textarea
    ].each do |element|
      define_method(element) do |&block|
        child = Crimson::Element.new(tag: element, parent: self)
        Docile.dsl_eval(child, &block) if block
        child
      end
    end
  end
end