require 'rails_helper'

describe WebsitesController do
  
  before :each do
    sign_out :user
  end
  
  describe "GET index" do
    it "returns all websites" do
      FactoryGirl.create_list(:website, 2)
      get 'index', :format => :json
      JSON.parse(response.body)["websites"].count.should == 2
    end
  end
  
end