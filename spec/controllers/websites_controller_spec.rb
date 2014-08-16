require 'rails_helper'

describe WebsitesController do

  describe "GET index" do
    it "returns all websites" do
      FactoryGirl.create_list(:website, 2)

      get 'index', :format => :json

      JSON.parse(response.body)["websites"].count.should == 2
    end
  end

  describe "GET search" do
    it "returns website last scrapping date" do
      website = FactoryGirl.create(:website, :url => "www.foo.bar")
      FactoryGirl.create(:scrapping, :website => website, :date => Date.parse("01/01/2010"))

      get 'search', :format => :json, :url => "www.foo.bar"

      websites = JSON.parse(response.body)["websites"]
      websites.count.should == 1
      websites[0]["last_scrapping_date"].should == "2010-01-01"
    end
  end

end