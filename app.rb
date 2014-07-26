require 'bundler'
Bundler.require

require 'securerandom'

require 'sinatra/asset_pipeline'

module Chat
  class App < Sinatra::Base
    set :views,         File.dirname(__FILE__) + '/views'
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :app_root,      File.expand_path(File.dirname(__FILE__))

    APP_ROOT = settings.app_root

    set :assets_protocol, :http
    set :assets_css_compressor, :sass
    set :assets_js_compressor, :uglify

    register Sinatra::AssetPipeline

    get "/" do
      @users = [{id: 'bob'}, {id: SecureRandom.random_number(100000000).to_s, current: true}].to_json
      haml :index
    end
  end
end
