# frozen_string_literal: true

require 'hashie'
require_relative 'model_change'
require_relative 'utilities'
require_relative 'mash'

module Crimson
  class Model < SimpleDelegator
    attr_reader :observers, :revisions, :local, :revision_number

    def initialize
      @observers = {}
      @revisions = [Mash.new]
      @revision_number = 1
      @max_number_of_revisions = 2
      @local = Mash.new

      super(local)
    end

    def add_observer(observer, handler = :on_commit)
      observers[observer] = observer.method(handler)
    end

    def remove_observer(observer)
      observers.delete(observer)
    end

    def notify_observers(changes)
      observers.each { |_observer, handler| handler.call(self, changes) }
    end

    def modify(modifications = {})
      local.merge(modifications)
    end

    def changed?(*keys)
      if keys.empty?
        local != master
      else
        keys.map { |key| local[key] != master[key] }.any?(true)
      end
    end

    def changes(*keys)
      keys = ( master.keys | local.keys ) if keys.empty?
      diff = Mash.new

      keys.each do |k|
        v1 = master[k]
        v2 = local[k]
        diff[k] = ModelChange.new(v1, v2) if v1 != v2
      end

      diff
    end

    def new_changes(*keys)
      changes(*keys).transform_values(&:new_value)
    end

    def master
      revisions.last
    end

    def commit!(*keys)
      if changed?(*keys)
        notify_observers(new_changes(*keys))
        apply_changes!(*keys)
      end
    end

    def apply_changes!(*keys)
      if keys.empty?
        revisions << Utilities.deep_copy(local)
      else
        revisions << Utilities.deep_copy(master)
        keys.each { |key| master[key] = Utilities.deep_copy(local[key]) }
      end

      @revision_number += 1
      revisions.shift if revisions.length > @max_number_of_revisions
    end

    def reload!
      @local = Utilities.deep_copy(master)
    end

    def rollback!
      if revisions.length > 1
        @local = revisions.pop
      else
        reload!
      end
    end
  end
end
