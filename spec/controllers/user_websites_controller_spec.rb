require "rails_helper"

describe UserWebsitesController do
  let(:user) { FactoryGirl.create(:user, :email => "foo@bar.com", :authentication_token => "foobar") } 

  describe "index" do
    context "authenticated user" do
      it "returns user websites" do
        FactoryGirl.create_list(:user_website, 2, :user => user)
        get :index, :token => "foobar", :format => :json
        resp = JSON.parse(response.body)
        resp["user_websites"].count.should == 2
      end
    end

    context "unauthenticated user" do
      it "returns 401" do
        get :index, :token => "", :format => :json
        response.code.should == "401"
      end
    end
  end
end