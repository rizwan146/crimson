require_relative 'publisher'

module Crimson
  class Var
    include Crimson::Publisher
    
    protected

    attr_reader :subscribers, :channel

    public

    attr_writer :on_changed
    
    def initialize(value = nil)
      @value = value
      @channel = EventMachine::Channel.new
      @subscribers = {}
    end

    def get
      @value
    end

    def set(value)
      old_value = @value
      @value = value
      
      on_changed&.call(value, old_value)
      emit(value)
    end

    def bind(other_var)
      raise TypeError unless other_var.is_a?(Var)
      other_var.add_subscriber(self, :on_bind_value_changed)
    end

    def on_bind_value_changed(*args)
      var, value = args
      var.set(value)
    end
  end
end