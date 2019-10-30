# frozen_string_literal: true

module Crimson
  class Renderer
    protected

    attr_writer :widget, :updater

    public

    attr_reader :model, :widget, :updater

    def initialize(opts = {})
      self.model = opts[:model]
      self.widget = opts[:widget]
      self.updater = opts[:updater]
    end

    def model=(m)
      @model&.delete_observer(self)
      @model = m
      @model&.add_observer(self)
    end

    def update
      updater&.call(model, widget)
    end
  end
end
