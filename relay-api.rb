require 'sinatra'
require 'sinatra/config_file'
require 'json'

#read the config file and set the port
config_file 'config.yml'
set :port, settings.port

# Specify the authorization logic
use Rack::Auth::Basic, 'Authorization Required' do |username, password|
  username == 'admin' and password == 'admin'
end

#protected pages
get '/' do
  'Nothing to see here - Move along!'
end

get '/on' do
    #set the relay to on and send success or failure message
    content_type :json
    { :success => true, :message => '' }.to_json
end

get '/off' do
    #set the relay to off and send success or failure message
    content_type :json
    { :success => true, :message => '' }.to_json
end

get '/status' do
    #get the relay status and return it
    content_type :json
    { :state => 1, :message => '' }.to_json
end