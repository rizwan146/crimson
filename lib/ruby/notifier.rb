
require_relative 'base'

module Crimson
  class Notifier
    def initialize()

    end

    def notify(msg)
      object = app.objects[msg["id"]]
      object.notify(msg["event"].to_sym, msg["meta"])
    end

    def app
      Crimson::Application.instance
    end
  end
end