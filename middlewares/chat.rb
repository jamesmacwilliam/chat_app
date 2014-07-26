require 'faye/websocket'
require 'thread'
require_relative '../lib/redis_client'
require_relative '../lib/bob_bot'

module Chat
  class Backend
    KEEPALIVE_TIME = 15 # in seconds

    attr_accessor :app, :clients, :redis

    def initialize(app)
      @app     = app
      @clients = []
      Thread.new do
        RedisClient.subscribe do |on|
          on.message do |channel, msg|
            message_handler(msg)
          end
        end
      end
    end

    def send_to_clients(msg)
      clients.each {|ws| ws.send(msg) }
    end

    def message_handler(data)
      send_to_clients(data)
      response = BobBot.new(data).get_response
      send_to_clients(response) if response
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})
        ws.on :open do |event|
          clients << ws
        end

        ws.on :message do |event|
          RedisClient.publish event.data
        end

        ws.on :close do |event|
          clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response
      else
        app.call(env)
      end
    end
  end
end
