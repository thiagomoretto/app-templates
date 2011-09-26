require 'test/test_helper'

class WebTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def browser
    @browser ||= Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  end

  def test_should_say_hello_world
    browser.get '/'
    
    assert browser.last_response.ok?
    assert_equal 'Hello World', browser.last_response.body
  end
end
