require File.dirname(__FILE__) + '/spec_helper'

describe "My Sinatra App" do

  it "should say Hello World" do
    get '/'
    
    last_response.should be_ok
    last_response.body.should == hello_world_string
  end
  
end
