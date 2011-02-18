require File.join(File.dirname(__FILE__), 'spec_helper')

def path(p)
  { 'PATH_INFO' => p }
end

describe Kazoo::Router do

  
  describe "dispatch mode" do
    
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
      @router.call(path '/something').should eq(@proper_response)
      @router.call(path '/something/else').should eq(@proper_response)
    end
    
    it "sets the kazoo params" do
      env = path '/something/123'
      @router.call(env)
      env['kazoo']['params'].should eq({'id' => '123'})
    end
    
    it "matches later routes properly" do
      @router.call(path '/something_else/testing_blah').should eq(@proper_response2)
    end
    
    it "allows for a default app" do
      router = Kazoo::Router.map do
        default_app lambda { |hash|
          raise "hell" unless hash
          [200, {'Content-Type' => 'text/plain'}, "Hey!"]
        }
      end
    end
    
  end
  
  
  describe "app mode" do
    
    before :each do
      @router = Kazoo::Router.map do
        set :mode, :app
        match '/testing', :view => 'good'
      end
    end
    
    it "returns a hash" do
      @router.call(path '/testing').should eq({'view' => 'good'})
    end
    
    
  end
  
  
end
