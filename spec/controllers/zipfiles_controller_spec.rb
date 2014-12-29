require "rails_helper"

describe ZipfilesController do
  login_user
  
  describe "GET index" do
    it "returns all zipfiles" do
      FactoryGirl.create(:zipfile, :key => "foo.zip")
      FactoryGirl.create(:zipfile, :key => "bar.zip")
      get :index, :format => :json
      resp = JSON.parse(response.body)["zipfiles"]
      resp.count.should == 2
      resp[0]["url"].scan(/(https:\/\/photozipper-dev.s3.amazonaws.com\/foo.zip\?AWSAccessKeyId=foobar&Expires=.*&Signature=.*)/).first.should_not == nil
      resp[0]["key"].should == "foo.zip"
      resp[1]["url"].scan(/(https:\/\/photozipper-dev.s3.amazonaws.com\/bar.zip\?AWSAccessKeyId=foobar&Expires=.*&Signature=.*)/).first.should_not == nil
      resp[1]["key"].should == "bar.zip"
    end

    it "destroys zipfles older than 1 day" do
      z1 = FactoryGirl.create(:zipfile, :key => "z1.zip", :created_at => 23.hours.ago)
      z2 = FactoryGirl.create(:zipfile, :key => "z2.zip", :created_at => 25.hours.ago)

      get :index, :format => :json
      resp = JSON.parse(response.body)["zipfiles"]
      resp.count.should == 1
      resp[0]["key"].should == "z1.zip"

      Zipfile.all.should == [z1]
    end
  end
end