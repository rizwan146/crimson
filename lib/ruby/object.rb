# frozen_string_literal: true

require 'tree'
require 'hashie'
require_relative 'model'
require_relative 'utilities'

module Crimson
  class Object < Model
    attr_reader :id, :tag, :node, :event_handlers

    def initialize(tag)
      super()

      @id = :"object_#{Utilities.generate_id}"
      @tag = tag.to_sym
      @node = Tree::TreeNode.new(id, self)
      @event_handlers = Hashie::Mash.new
    end

    def on_event(message)
      raise ArgumentError unless event_handlers.key?(message.event)

      event_handlers[message.event].each { |functor| functor.call(message.data) }
    end

    def on(event, &block)
      raise ArgumentError unless block_given?

      event_handlers[event] = [] unless event_handlers[event]
      event_handlers[event] << block

      self[:events] = event_handlers.keys
      commit!(:events)
    end

    def un(event, &block)
      raise ArgumentError unless event_handlers.key?(event)
      
      event_handlers[event].delete(block) if block_given?
        
      if event_handlers[event].empty? || !block_given?
        event_handlers.delete(event)
      end

      self[:events] = event_handlers.keys
      commit!(:events)
    end

    def parent
      node.parent&.content
    end

    def parent=(new_parent)
      raise ArgumentError unless new_parent.nil? || new_parent.is_a?(Crimson::Object)

      parent&.remove!(self)
      new_parent&.add(self)
    end

    def add(child, at_index = -1)
      raise ArgumentError unless child.is_a?(Crimson::Object)

      node.add(child.node, at_index)

      self[:children] = children.map(&:id)
    end

    def remove!(child)
      raise ArgumentError unless child.is_a?(Crimson::Object)

      node.remove!(child.node)

      self[:children] = children.map(&:id)
    end

    def siblings
      node.siblings.map(&:content)
    end

    def children
      node.children.map(&:content)
    end

    def root
      node.root.content
    end

    def commit_tree!(*keys)
      node.postordered_each do |sub_node|
        object = sub_node.content
        
        if object.changed?
          changes = object.new_changes(*keys)
          
          observers.keys.each do |observer|
            observer.observe(object) unless observer.observing?(object)
            observer.on_commit(object, changes)
          end

          object.apply_changes!
        end
      end
    end

    def inspect
      to_s
    end

    def to_s
      id.to_s
    end
  end
end
