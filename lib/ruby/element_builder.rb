# frozen_string_literal: true

require_relative 'element'

module Crimson
  module ElementBuilder
    %i[
      button
      canvas
      div
      form
      h1
      h2
      h3
      h4
      h5
      h6
      iframe
      img
      input
      label
      ul
      ol
      li
      p
      select
      table
      textarea
    ].each do |element|
      define_method(element.capitalize) do |&block|
        child = Element.new(tag: element)
        child[:parent] = is_a?(Element) ? self : nil
        Docile.dsl_eval(child, &block) if block_given?
        child
      end
    end

    def self.build(&block)
      element = block.call
    end

    def self.generate_id
      :"crimson_#{pool.keys.size}"
    end
  end
end
