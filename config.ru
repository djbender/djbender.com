require 'bundler/setup'
require 'sinatra/base'

ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rack/use_www.rb'
use Rack::UseWww

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base  
  require 'dalli'
  require 'rack/cache'
  
  set :static_cache_control, [:public, :max_age => 60]

  if memcache_servers = ENV['MEMCACHE_SERVERS']
    use Rack::Cache,
      verbose: true,
      metastore:   "memcached://#{memcache_servers}",
      entitystore: "memcached://#{memcache_servers}"
  end

  get '/unplayed' do
    cache_control :public, :must_revalidate, :max_age => 60
    send_file 'static/unplayed/index.html'
  end

  not_found do
    expires 0, :public, :no_cache
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  get(/.+/) do
    cache_control :public, :must_revalidate, :max_age => 60
    send_sinatra_file(request.path) {404}
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i  
    static_path = File.join(File.dirname(__FILE__), 'static', path)
    static_path = File.join(static_path, 'index.html') unless static_path =~ /\.[a-z]+$/i
    if File.exist?(file_path) 
      send_file(file_path) 
    elsif File.exist?(static_path)
      send_file(static_path)
    else
      missing_file_block.call
    end
  end

end

use Rack::Deflater

run SinatraStaticServer
