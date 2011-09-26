require 'rubygems'
require 'sinatra'
require 'mongo'

require 'yajl'
require 'yajl/json_gem'

configure :production do
  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

get '/' do
  "Hello Mongo!"
end

post '/store/:database/:collection' do
  database, collection = params[:database], params[:collection]
  json_object = params[:object]

  mongo = Mongo::Connection.new("localhost", 27017, :pool_size => 1, :timeout => 5)
  mongo_coll = mongo.db(database).collection(collection)
  mongo_coll.insert(JSON.parse(json_object))

  content_type 'text/json'

  { :result => :ok }.to_json
end

get '/query/:database/:collection' do
  database, collection = params[:database], params[:collection]
  json_query = params[:query] || '{}'

  mongo = Mongo::Connection.new("localhost", 27017, :pool_size => 1, :timeout => 5)
  mongo_coll = mongo.db(database).collection(collection)
  data = mongo_coll.find(JSON.parse(json_query))

  result          = {}
  result[:total]  = data.count
  result[:rows]   = data.collect{ |doc| doc }

  content_type 'text/json'
  result.to_json
end
