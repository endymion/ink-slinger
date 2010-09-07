require 'spec_helper'

describe HomeController do
  
  describe "GET index" do
    it "produces a front news page" do
      get :periodical
    end
  end
  
end
