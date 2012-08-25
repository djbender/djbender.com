require 'bundler/setup'
require 'sinatra/base'

ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'rack/use_www.rb'

use Rack::UseWww

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base  

  get '/unplayed' do
    send_file 'static/unplayed/index.html'
  end

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
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

run SinatraStaticServer
