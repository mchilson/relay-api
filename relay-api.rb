require 'sinatra'
require 'sinatra/config_file'
require 'json'
require 'pi_piper'

include PiPiper

#read the config file and set the port
config_file 'config.yml'
set :port, settings.port
set :bind, settings.ip

$pin = PiPiper::Pin.new(:pin => 2, :direction => :out)

# Specify the authorization logic
use Rack::Auth::Basic, 'Authorization Required' do |username, password|
  username == 'admin' and password == 'admin'
end

#protected pages
get '/' do
  '<h2>Relay API</h2>
   <p><b>/on</b> - trigger the relay to the "on" position</p>
   <p><b>/off</b> - trigger the relay to the "off" position</p>
   <p><b>/status</b> - returns the current status of the relay (1 or 0)</p>'
end

get '/on' do
    #set the relay to on and send success or failure message
    begin
        $pin.on
	$pin.read
    rescue
    	content_type :json
    	{ :Success => 0, :State => $pin.value }.to_json
    else
    	content_type :json
    	{ :Success => 1, :State => $pin.value }.to_json
    end        
end

get '/off' do
    #set the relay to off and send success or failure message
    begin
        $pin.off
	$pin.read
    rescue
    	content_type :json
    	{ :Success => 0, :State => $pin.value }.to_json
    else
        content_type :json
    	{ :Success => 1, :State => $pin.value }.to_json
    end
end

get '/status' do
    #get the relay status and return it
    begin
    	$pin.read
    rescue
        content_type :json
        { :Success => 0, :State => $pin.value }.to_json
    else
        content_type :json
        { :Success => 1, :State => $pin.value }.to_json
    end
end