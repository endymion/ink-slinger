require 'spec_helper'
require 'caching_helper'

describe HomeController do
  
  describe "GET periodical" do
    it "produces a front news page" do
      get :news
    end
  end

  describe "branding" do

    it 'should find the right brand from miami.nightlifeobserver.com' do
      @request.host = 'miami.nightlifeobserver.com'
      get :news
      assigns[:current_brand].should == Brand.find(:first, :conditions => {
          :subdomain => 'miami',
          :domain_name => 'nightlifeobserver.com'
        })
    end

    it 'should find the right brand from the.miami.nightlifeobserver.com' do
      @request.host = 'the.miami.nightlifeobserver.com'
      get :news
      assigns[:current_brand].should == Brand.find(:first, :conditions => {
          :subdomain => 'miami',
          :domain_name => 'nightlifeobserver.com'
        })
    end

  end

  # Enable caching in the test environment to test this stuff, but beware that
  # you could overwrite the cached publication files during testing.  Be careful.
  describe "caching" do
    include CachingHelper
  
    it "should cache the news page" do
      requesting {get :news}.should be_cached
    end
  
    it "should send the news page to S3" do
      @request.host = 'miami.nightlifeobserver.local'
      ActionController::Caching::PagesS3.should_receive(:copy_cached_page_to_s3).
        with('miami.nightlifeobserver.com', '/index.html', '/tmp/index.html')
      get :news
    end
  
    it "should not send the news page to S3 for a brand with no application_domain" do
      @request.host = 'localhost'
      ActionController::Caching::PagesS3.should_not_receive(:copy_cached_page_to_s3)
      get :news
    end
  
  end

end
