# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Model
    class List < Base
      def initialize(data = [])
        super(data)
      end

      def data=(d)
        d.map! { |item| Base.new(item) }
        changed if d != @data
        @data = d
      end

      (Array.instance_methods - Object.instance_methods).each do |method|
        define_method(method) do |*args, &block|
          old_length = data.length
          result = data.send(method, *args, &block)
          if old_length != data.length
            data.map! { |item| item.is_a?(Base) ? item : Base.new(item) }
            changed
          end
          !result.equal?(data) && result.is_a?(Array) ? self.class.new(result) : result
        end
      end

      def [](index)
        data[index].data
      end

      def []=(index, value)
        data[index].data = value
      end

      def commit
        changed(data.any?(&:changed?)) unless changed?
        super
        data.each(&:commit)
      end
    end
  end
end
