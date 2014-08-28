require "rails_helper"

describe UsersController do

  describe "sign_in" do
    before(:each) do
      FactoryGirl.create(:user, :email => "foo@bar.com", :password => "azerty")
    end

    context "valid credentials" do  
      it "returns an authentication_token" do
        post :sign_in, :user => {:email => "foo@bar.com", :password => "azerty"}, :format => :json
        
        response.code.should == "200"
        JSON.parse(response.body)["token"].should_not == nil
      end
    end

    context "user has nil authentication_token" do  
      it "returns an authentication_token" do
        FactoryGirl.create(:user, :email => "foo2@bar.com", :password => "azerty2", :authentication_token => nil)
        post :sign_in, :user => {:email => "foo2@bar.com", :password => "azerty2"}, :format => :json

        JSON.parse(response.body)["token"].should_not == nil
      end
    end    

    context "email doesn't exists" do
      it "returns 400" do
        post :sign_in, :user => {:email => "wrong@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "password doesn't match" do
      it "returns 400" do
        post :sign_in, :user => {:email => "foo@bar.com", :password => "wrong"}, :format => :json
        
        response.code.should == "400"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing email" do
      it "returns 422" do
        post :sign_in, :user => {:password => "wrong"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing password" do
      it "returns 422" do
        post :sign_in, :user => {:email => "foo@bar.com"}, :format => :json
          
        response.code.should == "422"
        JSON.parse(response.body)["error"].should_not == nil
      end
    end
  end


  describe "create" do
    context "valid user" do
      it "creates user" do
        expect {
          post :create, :user => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "azerty"}, :format => :json
        }.to change{User.count}.by(1)
      end

      it "returns a auth token" do
        post :create, :user => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "azerty"}, :format => :json
        JSON.parse(response.body)["token"].should_not == nil
      end
    end

    context "password confirmation doesn't match password" do
      it "doesn't creates user" do
        expect {
          post :create, :user => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "wrong"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :user => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "wrong"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing email" do
      it "doesn't creates user" do
        expect {
          post :create, :user => {:password => "azerty", :password_confirmation => "azerty"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :user => {:password => "azerty", :password_confirmation => "azerty"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing password" do
      it "doesn't creates user" do
        expect {
          post :create, :user => {:email => "foo@bar.com"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :user => {:email => "foo@bar.com"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end
  end
end