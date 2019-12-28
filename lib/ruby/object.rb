# frozen_string_literal: true

require 'tree'
require_relative 'model'
require_relative 'utilities'

module Crimson
  class Object < Model
    attr_reader :id, :tag, :node

    def initialize(tag)
      super()

      @id = :"object_#{Utilities.generate_id}"
      @tag = tag.to_sym
      @node = Tree::TreeNode.new(id, self)

      puts("new object with id #{@id}")
    end

    def parent
      node.parent&.content
    end

    def parent=(new_parent)
      raise ArgumentError unless new_parent.nil? || new_parent.is_a?(Object)

      parent&.remove!(self)
      new_parent&.add(self)
    end

    def add(child, at_index = -1)
      raise ArgumentError unless child.is_a?(Object)

      node.add(child.node, at_index)

      self[:children] = children.map(&:id)
    end

    def remove!(child)
      raise ArgumentError unless child.is_a?(Object)

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

    def commit_tree!
      node.postordered_each do |sub_node|
        object = sub_node.content
        if object.changed?
          observers.keys.each do |observer|
            observer.observe(object) unless observer.observing?(object)
            observer.on_commit(object)
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
