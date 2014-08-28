require "rails_helper"

describe TokensController do

  describe "create" do
    before(:each) do
      FactoryGirl.create(:user, :email => "foo@bar.com", :password => "azerty")
    end

    context "valid credentials" do  
      it "returns an authentication_token" do
        post :create, :user => {:email => "foo@bar.com", :password => "azerty"}, :format => :json
        
        response.code.should == "200"
        JSON.parse(response.body)["token"].should_not == nil
      end
    end

    context "user has nil authentication_token" do  
      it "returns an authentication_token" do
        FactoryGirl.create(:user, :email => "foo2@bar.com", :password => "azerty2", :authentication_token => nil)
        post :create, :user => {:email => "foo2@bar.com", :password => "azerty2"}, :format => :json

        JSON.parse(response.body)["token"].should_not == nil
      end
    end    

    context "email doesn't exists" do
      it "returns 400" do
        post :create, :user => {:email => "wrong@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "password doesn't match" do
      it "returns 400" do
        post :create, :user => {:email => "foo@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing email" do
      it "returns 422" do
        post :create, :user => {:password => "wrong"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing password" do
      it "returns 422" do
        post :create, :user => {:email => "foo@bar.com"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end
  end
end