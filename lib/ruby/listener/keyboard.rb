# frozen_string_literal: true

require_relative 'base'

module Crimson
  module Listener
    class Keyboard < Base
      attr_accessor :filters
      def initialize(opts = {})
        default_opts = { events: [:keyup] }
        opts = default_opts.merge(opts)
        super(opts)
        self.filters = opts[:filters].map { |key| key.to_sym }
      end

      def update(meta)
        key = meta[:event][:key].to_sym
        updater&.call(model, meta) if filters.empty? || filters.include?(key)
      end
    end
  end
end
