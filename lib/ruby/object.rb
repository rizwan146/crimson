# frozen_string_literal: true

require 'tree'
require 'hashie'
require_relative 'model'
require_relative 'utilities'

module Crimson
  class Object < Model
    attr_reader :id, :tag, :node, :event_handlers, :added_children, :removed_children

    def initialize(tag)
      super()

      @id = :"object_#{Utilities.generate_id}"
      @tag = tag.to_sym
      @node = Tree::TreeNode.new(id, self)
      @event_handlers = Hashie::Mash.new

      @added_children = []
      @removed_children = []
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

      parent&.remove(self)
      new_parent&.add(self)
    end

    def add(child, at_index = -1)
      raise ArgumentError unless child.is_a?(Crimson::Object)
      raise ArgumentError if children.include?(child)

      node.add(child.node, at_index)

      self[:children] = children.map(&:id)
      added_children << child
    end

    def remove(child)
      raise ArgumentError unless child.is_a?(Crimson::Object)
      raise ArgumentError unless children.include?(child)
      
      node.remove!(child.node)

      self[:children] = children.map(&:id)
      removed_children << child
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
      # TODO: Unsure if this algorithm works for moved objects
      # eg. added, removed, then added again, under the same commit.
      
      node.breadth_each do |subnode|
        object = subnode.content
        
        observers.keys.each do |observer|
          object.added_children.each do |child|
            observer.observe(child)
          end

          object.removed_children.each do |child|
            observer.unobserve(child)
          end
        end

        object.added_children.clear
        object.removed_children.clear
        object.commit!(*keys)
      end
    end

    def inspect
      to_s
    end

    def to_s
      id.to_s
    end

    def ==(other)
      other.is_a?(Object) && other.id == id
    end

    def eql?(other)
      self == other
    end

    def hash
      id.hash
    end
  end
end
