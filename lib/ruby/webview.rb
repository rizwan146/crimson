require 'Qt'
require 'qtwebkit'
require 'eventmachine'

module Crimson
  class WebView
    def initialize()
      @app = Qt::Application.new(ARGV)
      @view = Qt::WebView.new
    end

    def qt
      @view
    end

    def start()
      show
      EM.add_periodic_timer(0.01) do
        @app.process_events
      end
    end

    def show()
      @view.show
    end

    def hide()
      @view.hide
    end

    def reload()
      @view.reload()
    end

    def load(url)
      @view.load(Qt::Url.new(url))
    end
  end
end