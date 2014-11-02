require "rails_helper"

describe ZipfilesController do
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
  end
end