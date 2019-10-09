# frozen_string_literal: true

module Crimson
  class ViewAdapter
    attr_reader :view, :renderer, :inserter

    def initialize(opts = {})
      unless opts.key?(:view) && opts.key?(:renderer)
        raise(ArgumentError, 'Expected view adapter to have a view and renderer.')
      end

      @view = opts[:view]
      @renderer = opts[:renderer]
      @inserter = opts[:inserter]

      @inserter ||= method(:default_inserter)
    end

    def default_inserter(view, children)
      while children.length < view.children.length
        view.remove(view.children.pop)
      end

      children.each_with_index do |child, index|
        if index < view.children.length
          view.replace(index, child)
        else
          view.append(child)
        end
      end
    end

    def <<(model)
      model = [model] unless model.is_a?(Array)
      children = model.map { |item| renderer.call(item) }
      inserter.call(view, children)
      self
    end
  end
end
