require "rails_helper"

describe Api::V1::Users::SessionsController do

  describe "sign_in" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create(:user, :email => "foo@bar.com", :password => "azerty")
    end

    context "valid credentials" do  
      it "returns an authentication_token" do
        post :create, :users => {:email => "foo@bar.com", :password => "azerty"}, :format => :json
        
        response.code.should == "200"
        JSON.parse(response.body)["users"]["token"].should_not == nil
      end
    end

    context "user has nil authentication_token" do  
      it "returns an authentication_token" do
        FactoryGirl.create(:user, :email => "foo2@bar.com", :password => "azerty2", :authentication_token => nil)
        post :create, :users => {:email => "foo2@bar.com", :password => "azerty2"}, :format => :json

        JSON.parse(response.body)["users"]["token"].should_not == nil
      end
    end    

    context "email doesn't exists" do
      it "returns 400" do
        post :create, :users => {:email => "wrong@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "password doesn't match" do
      it "returns 400" do
        post :create, :users => {:email => "foo@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing email" do
      it "returns 422" do
        post :create, :users => {:password => "wrong"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing password" do
      it "returns 422" do
        post :create, :users => {:email => "foo@bar.com"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end
  end
end