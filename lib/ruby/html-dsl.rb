# frozen_string_literal: true

require_relative 'element'

module Crimson
  module HtmlDsl
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
      define_method(element) do |&block|
        parent = is_a?(Element) ? self : Crimson::Application.instance.root
        child = Crimson::Element.new(tag: element, parent: parent)
        Docile.dsl_eval(child, &block) if block
        child
      end
    end
  end
end

extend Crimson::HtmlDsl
