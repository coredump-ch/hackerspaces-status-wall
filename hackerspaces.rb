require 'sinatra'
require 'coffee-script'
require 'net/http'
require 'uri'
require 'json'

helpers do
  def getSpaceInfo(uri, limit = 4)
    begin
      return {:error => "To many HTTP redirects"}.to_json if limit == 0
      response = Net::HTTP.get_response(uri)
      case response
      when Net::HTTPSuccess then
        response.body
      when Net::HTTPRedirection then
        location = URI.parse(response['Location'])
        location = uri.merge(location) if location.relative?
        getSpaceInfo URI.parse(response['location']), limit - 1
      else
        {:error => "#{response.value}"}.to_json
      end
    rescue => e
      if uri.scheme == 'https'
        uri.scheme = 'http'
        getSpaceInfo uri, limit
      else
        {:error => e.message}.to_json
      end
    end
  end
  
end

get '/wall' do
  haml :wall
end

get '/styles.css' do
  scss :styles
end

get '/main.js' do
  coffee :main
end

post '/proxy' do
  headers 'Content-Type' => 'application/json'
  getSpaceInfo URI.parse(request.body.read)
end

get '*' do
  redirect '/wall'
end
