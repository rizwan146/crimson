require 'hashie'

module Crimson
  class Mash < Hashie::Mash
    disable_warnings :display, :drop
  end
end