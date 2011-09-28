require 'rubygems'
require 'sinatra'

configure :production do
  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

get '/' do
  "Hello World"
end
