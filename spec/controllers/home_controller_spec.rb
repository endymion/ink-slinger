require 'spec_helper'

describe HomeController do
    
  describe "- Routing -" do

    it "routes / to home controller" do
      { :get => "/" }.should
        route_to( :controller => 'home', :action => 'index' )
    end
    it "generates home URL as /" do
      assert_generates "/", { :controller => "home", :action => "index" }
    end
    it "generates http://domain.com with :host => domain.com" do
      controller.url_for(:controller => 'home', :action => 'index',
        :host => 'domain.com').should ==
        'http://domain.com/'
    end
    it "generates http://subdomain.domain.com with :host => domain.com, :subdomain => subdomain" do
      controller.url_for(
        :controller => 'home', :action => 'index',
        :host => 'domain.com', :subdomain => 'subdomain').should ==
        'http://subdomain.domain.com/'
    end

    it "does not expose an admin controller" do
      { :get => "/admin" }.should_not be_routable
    end

    # I haven't been able to URL (with host, subdomain) parsing from RSpec.
    # Therefore, subdomain and host based routing is tested with Cucumber.
    # it "routes http://bravenewmedia.com to :action => bravenewmedia" do
    #   r = Rails.application.routes
    #   set_test_host('bravenewmedia.com') # ??
    #   controller.request.host = 'bravenewmedia.com' # ?
    #   (r.recognize_path "/").should ==
    #     { :controller => "home", :action => "bravenewmedia"}
    # end
    
  end
  
end
