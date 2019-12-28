# frozen_string_literal: true

module Crimson
  module Utilities
    def self.generate_id
      (Time.now.to_f * 100_000_000.0).to_i
    end

    def self.deep_copy(o)
      Marshal.load(Marshal.dump(o))
    end
  end
end
