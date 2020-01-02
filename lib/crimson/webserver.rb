require 'sinatra/base'

module Crimson
  class WebServer < Sinatra::Base
    set :public_folder, "#{__dir__}/../"

    def initialize(template)
      super()
      
      @template = template
    end

    get '/' do
      @template
    end
  end
end