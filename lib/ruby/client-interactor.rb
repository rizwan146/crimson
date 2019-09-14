# frozen_string_literal: true

require 'set'
require 'websocket-eventmachine-server'
require_relative 'publisher'
require_relative 'base'

module Crimson
  class ClientInteractor
    include Crimson::Publisher

    public

    attr_reader :id, :socket

    protected

    attr_reader :channel, :subscribers, :object_cache
    @@id_count = 1

    public

    def initialize(socket)
      @id = :"client_#{@@id_count}"
      @@id_count += 1

      @socket = socket
      socket.onopen(&method(:on_open))
      socket.onmessage(&method(:on_message))
      socket.onclose(&method(:on_close))

      @channel = EventMachine::Channel.new
      @subscribers = {}

      @object_cache = {}
    end

    def is_cached?(object)
      object_cache.key?(object.id)
    end

    def cache(configuration)
      object_cache[configuration[:id]] = configuration
      configuration[:children]&.each { |child| cache(child) }
    end

    def uncache(configuration)
      object_cache.delete(configuration[:id])
      configuration[:children]&.each { |child| uncache(child) }
    end

    def create(object, configuration)
      return if is_cached?(object)

      cache(configuration)
      unless is_subscriber?(object)
        object.link(self, :on_object_published, :on_client_published)
      end

      send(configuration)
    end

    def update(object, configuration)
      return unless is_cached?(object)

      send(configuration)
    end

    def invoke(object, configuration)
      return unless is_cached?(object)

      send(configuration)
    end

    def destroy(object, configuration)
      return unless is_cached?(object)

      uncache(configuration)
      object.unlink(self) if is_subscriber?(object)

      send(configuration)
    end

    def send(message)
      app.logger.debug "[#{self.class}::#{__method__}] Sending to #{id}, message: #{message}."

      message = message.to_json if message.is_a?(Hash)
      socket.send(message)
    end

    def on_open(*_args)
      app.logger.debug "[#{self.class}::#{__method__}] #{id} connected."
      app.add_client(self)

      app.root.link(self, :on_object_published, :on_client_published)

      app.root.emit :create
    end

    def on_message(message, _type)
      app.logger.debug "[#{self.class}::#{__method__}] Message recieved from #{id}."

      message = symbolize(JSON.parse(message))
      message[:meta].merge!(client: id)

      channel << message
    end

    def on_close(*_args)
      app.logger.debug "[#{self.class}::#{__method__}] #{id} disconnected."

      app.root.unlink(self)
    end

    def on_object_published(args)
      object, configuration = *args
      action = configuration[:action]

      case action
      when :create then create(*args)
      when :update then update(*args)
      when :destroy then destroy(*args)
      when :invoke then invoke(*args)
      else app.logger.warn "[#{self.class}::#{__method__}] Unable to handle unknown action '#{action}'."
      end
    end

    def symbolize(hash)
      if hash.is_a?(Hash)
        symbolizable_values = %i[id event]
        hash.keys.each do |key|
          hash[(begin
                  key.to_sym
                rescue StandardError
                  key
                end) || key] = symbolize(hash.delete(key))
        end

        symbolizable_values.each { |sym| hash[sym] = hash[sym].to_sym if hash.key?(sym) && hash[sym].is_a?(String) }
      end

      hash
    end

    def ==(client)
      raise TypeError unless client.is_a?(self.class)

      id == client.id
    end

    def app
      Crimson::Application.instance
    end
  end
end
