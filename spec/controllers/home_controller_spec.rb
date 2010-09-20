require 'spec_helper'
require 'caching_helper'

describe HomeController do
  
  describe "GET periodical" do
    it "produces a front news page" do
      get :news
      response.should be_success
    end
  end

  describe "branding" do

    it 'should find the right brand from miami.nightlifeobserver.com' do
      @request.host = 'miami.something-chronicle.com'
      get :news
      assigns[:current_brand].should == Brand.find(:first, :conditions => {
          :subdomain => 'miami',
          :domain_name => 'something-chronicle.com'
        })
    end

    it 'should find the right brand from the.miami.nightlifeobserver.com' do
      @request.host = 'the.miami.something-chronicle.com'
      get :news
      assigns[:current_brand].should == Brand.find(:first, :conditions => {
          :subdomain => 'miami',
          :domain_name => 'something-chronicle.com'
        })
    end

  end

  describe "caching" do
    include CachingHelper
  
    it "should cache the news page" do
      requesting {get :news}.should be_cached
    end
  
    it "should send the news page to S3" do
      @request.host = 'miami.something-chronicle.com'
      ActionController::Caching::PagesS3.should_receive(:copy_cached_page_to_s3).
        with('miami.something-chronicle.com', '/index.html', './tmp/index.html')
      get :news
    end
  
    it "should not send the news page to S3 for a brand with no application_domain" do
      @request.host = 'localhost'
      ActionController::Caching::PagesS3.should_not_receive(:copy_cached_page_to_s3)
      get :news
    end

    it "should include a cache-control on the news page" do
      get :news
      response.should be_success
      response.headers["Cache-Control"].should_not be_nil
      response.headers["Cache-Control"].should match /max\-age\=3600/ # 1.hour
    end

  end

end
