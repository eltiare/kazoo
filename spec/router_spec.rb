require File.join(File.dirname(__FILE__), 'spec_helper')


describe Kazoo::Router do

  before :each do
    @proper_response = [200, {'Content-Type' => 'text/plain'}, 'Yay!']
    @proper_response2 = [200, {'Content-Type' => 'text/plain'}, 'Response2']
    @not_found_response = [404, {"X-Cascade"=>"pass", "Content-Type"=>"text/plain"}, "The requested URI is not found"]
    
    handler = lambda { @proper_response }
    handler2 = lambda { @proper_response2 }
    
    @router = Kazoo::Router.map do
      match '/something/:id', :to => handler
      match '/something', :to => handler
      match '/something_else', :to => handler2
    end
    
  end
  
  it "routes to the proper handler" do
    @router.call({ 'PATH_INFO' => '/something' }).should eq(@proper_response)
    @router.call({ 'PATH_INFO' => '/something/else'}).should eq(@proper_response)
  end
  
  it "sets the kazoo params" do
    env = { 'PATH_INFO' => '/something/123' }
    @router.call(env)
    env['kazoo']['params'].should eq({'id' => '123'})
  end
  
  it "matches later routes properly" do
    env = { 'PATH_INFO' => '/something_else/testing_blah' }
    @router.call(env).should eq(@proper_response2)
  end
  
end
