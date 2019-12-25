# frozen_string_literal: true

require_relative 'model_change'

module Crimson
  module Model
    attr_reader :observers, :revisions, :local

    def initialize
      super if defined?(super)

      @observers = {}
      @revisions = [{}]
      @local = {}
    end

    def add_observer(observer, handler = :on_commit)
      observers[observer] = observers.method(handler)
    end

    def remove_observer(observer)
      observers.delete(observer)
    end

    def notify_observers
      observers.each { |_observer, handler| handler.call(changes) }
    end

    def changed?
      local != master
    end

    def changes
      keys = master.keys | local.keys
      diff = {}

      keys.each do |k|
        v1 = master[k]
        v2 = local[k]
        diff[k] = ModelChange.new(v1, v2) if v1 != v2
      end

      diff
    end

    def master
      revisions.last
    end

    def commit!
      if changed?
        notify_observers
        apply_changes!
      end
    end

    def apply_changes!
      revisions << local.dup
    end

    def reload!
      @local = master.dup
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
