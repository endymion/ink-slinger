require 'spec_helper'

describe HomeController do
  before do
    @r = ActionController::Routing::Routes
  end
    
  describe "- Routing -" do

    it "routes / to home controller" do
      { :get => "/" }.should route_to( :controller => "home", :action => "index" )
    end
    it "generates home URL as /" do
      assert_generates "/", { :controller => "home", :action => "index" }
    end

    it "routes http://subdomain.domain.com to :host => domain.com, :subdomain => subdomain" do
      controller.request.host = 'subdomain.test.com'
      (@r.recognize_path "/").should 
        equal({ :controller => "home", :action => "index", :host => 'domain.com', :subdomain => 'subdomain'})
    end
    it "generates http://subdomain.domain.com for :host => domain.com, :subdomain => subdomain" do
      # controller.request.host = 'subdomain.domain.com'
      controller.url_for(:controller => 'home', :action => 'index', :host => 'domain.com', :subdomain => 'subdomain').should
        equal 'http://subdomain.domain.com/'
    end

    it "does not expose an admin controller" do
      { :get => "/admin" }.should_not be_routable
    end
    
  end
  
end
