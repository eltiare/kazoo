require File.join(File.dirname(__FILE__), '../spec_helper')

describe Kazoo::Router::Route do
  
  before(:each) do
    blk = lambda { [200, { 'Content-Type' => 'text/plan' }, 'Success!'] }
    @route = Kazoo::Router::Route.new('/your/:relative/is/:adjective', :to => blk)
    @route2 = Kazoo::Router::Route.new('/testing', :to => blk, :test => 3)
    @app_route = Kazoo::Router::Route.new('/testing', :app_mode => true)
  end
  
  it "extracts the variables from a path" do
    @route.named_params.should eq(['relative', 'adjective'])
  end
  
  it "converts param keys to a string" do
    @route2.extract_params('/testing/').keys.should eq(['test'])
  end
  
  it "generates a path with variables" do
    @route.path(:relative => 'mom', :adjective => 'huge').should eq(
      '/your/mom/is/huge'
    )
  end
  
  it "generates a path with extranous variables" do
    @route.path(:relative => 'mom', :adjective => 'huge', :laughs => 1, :true => 'yes').should eq(
      '/your/mom/is/huge?laughs=1&true=yes'
    )
  end
  
  it "throws an error if a required var is left out" do
    lambda { @route.path(:relative => 'mom') }.should raise_error(ArgumentError, /adjective/)
  end
  
  it "properly forms a matching regexp" do
    @route2.to_regexp.inspect.should eq('/^\/testing\//')
    @route.to_regexp.inspect.should eq('/^\/your\/([^\/]+)\/is\/([^\/]+)\//')
  end
  
  it "doesn't match similar segments" do
    @route2.extract_params('/testing_and_stuff').should eq(nil)
  end
  
  it "matches exactly when acting as an app route" do
    @app_route.to_regexp.inspect.should eq('/^\/testing\/$/')
  end
  
end
