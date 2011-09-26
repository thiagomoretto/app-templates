require 'test/test_helper'

class WebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    db = Mongo::Connection.new.db('test_db')
    db.drop_collection('users')
  end

  def browser
    @browser ||= Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  end

  def test_should_say_hello_world
    browser.get '/'
    
    assert browser.last_response.ok?
    assert_equal 'Hello Mongo!', browser.last_response.body
  end

  def test_should_insert_a_object_in_a_mongo_collection
    object = { :name => 'Morettones', :age => 25 }

    browser.post '/store/test_db/users', { :object => object.to_json }
    
    assert browser.last_response.ok?
    assert_equal 'ok', JSON.parse(browser.last_response.body)['result']
  end

  def test_should_query_for_objects_from_a_mongo_collection
    object = { :name => 'Morettones', :age => 25 }
    browser.post '/store/test_db/users', { :object => object.to_json }

    query = { :age => { "$gt" => 23 } }
    browser.get '/query/test_db/users', { :query => query.to_json }

    assert browser.last_response.ok?

    result = JSON.parse(browser.last_response.body)

    assert_equal 1            , result['total']
    assert_equal "Morettones" , result['rows'].first['name']
  end
end
