require 'bundler/setup'
require 'sinatra'
require_relative '../lib/redis_client'

Sinatra::Application.environment = :test

Bundler.require :default, Sinatra::Application.environment

require 'rspec'

RSpec.configure do |config|
  config.before(:each) { RedisClient.new.redis.flushdb }
end
