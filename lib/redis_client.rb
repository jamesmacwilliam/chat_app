require 'redis'
require 'json'
require 'erb'

CHANNEL = 'chat'

DEFAULT_PARAMS = {host: '127.0.0.1', db: 1, port: 6379}

class RedisClient
  attr_accessor :redis

  class << self
    def subscribe
      new.redis.subscribe(CHANNEL) {|on| yield(on) }
    end

    def publish(data)
      new.publish(data)
    end
  end

  def initialize
    @redis = Redis.new(params_from_url || DEFAULT_PARAMS)
  end

  def publish(data)
    redis.publish(CHANNEL, sanitize(data))
  end

  private

  def sanitize(message)
    json = JSON.parse(message)
    json.each {|key, value| json[key] = ERB::Util.html_escape(value) }
    JSON.generate(json)
  end

  def params_from_url(url = ENV['REDISTOGO_URL'])
    @url_params ||= if url
      uri = URI.parse(url)
      {host: uri.host, port: uri.port, password: uri.password}
    end
  end
end
