# frozen_string_literal: true

require 'hashie'
require_relative 'model_change'
require_relative 'utilities'

module Crimson
  class Model < SimpleDelegator
    attr_reader :observers, :revisions, :local, :revision_number

    def initialize
      @observers = {}
      @revisions = [Hashie::Mash.new]
      @revision_number = 1
      @max_number_of_revisions = 2
      @local = Hashie::Mash.new

      super(local)
    end

    def add_observer(observer, handler = :on_commit)
      observers[observer] = observer.method(handler)
    end

    def remove_observer(observer)
      observers.delete(observer)
    end

    def notify_observers
      observers.each { |_observer, handler| handler.call(self) }
    end

    def modify(modifications = {})
      local.merge(modifications)
    end

    def changed?
      local != master
    end

    def changes
      keys = master.keys | local.keys
      diff = Hashie::Mash.new

      keys.each do |k|
        v1 = master[k]
        v2 = local[k]
        diff[k] = ModelChange.new(v1, v2) if v1 != v2
      end

      diff
    end

    def new_changes
      changes.transform_values{ |change| change.new_value }
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
      revisions << Utilities.deep_copy(local)
      @revision_number += 1
      revisions.shift if revisions.length > @max_number_of_revisions
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
