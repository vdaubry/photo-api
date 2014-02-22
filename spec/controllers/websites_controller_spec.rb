require 'spec_helper'

describe WebsitesController do

  describe "GET index" do
    it "returns all websites" do
      FactoryGirl.create_list(:website, 2)

      get 'index', :format => :json

      JSON.parse(response.body)["websites"].count.should == 2
    end
  end

end