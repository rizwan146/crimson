# frozen_string_literal: true

require_relative '../object'

module Crimson
  class Dropdown < Widget
    attr_reader :selected

    def initialize(*options, parent: app.root)
      raise(ArgumentError, "Expected at least one option.") if options.length == 0
      super(parent: parent, tag: 'select')

      @options = {}
      options.each { |option| add_option option }
      
      @selected = options.first
      
      meta.push("value")
      update(meta: meta)
    end

    def selected=(option)
      raise KeyError unless @options.key?(option)
      @selected = option
      update(attributes: { value: @selected })
    end

    def options
      @options.keys
    end

    def add_option(option)
      remove_option(option) if @options.key?(option)
      object = Crimson::Data.new(value: option, tag: 'option', parent: self)
      @options[option] = object.id
    end

    def remove_option(option)
      unbond(@options[option])
      @options.delete(option)
    end
  end
end
