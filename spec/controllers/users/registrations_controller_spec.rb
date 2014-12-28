require "rails_helper"

describe Users::RegistrationsController do
  
  describe "create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    context "valid user" do
      it "creates user" do
        expect {
          post :create, :users => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "azerty"}, :format => :json
        }.to change{User.count}.by(1)
      end

      it "returns a auth token" do
        post :create, :users => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "azerty"}, :format => :json
        JSON.parse(response.body)["token"].should_not == nil
      end
    end

    context "password confirmation doesn't match password" do
      it "doesn't creates user" do
        expect {
          post :create, :users => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "wrong"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :users => {:email => "foo@bar.com", :password => "azerty", :password_confirmation => "wrong"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing email" do
      it "doesn't creates user" do
        expect {
          post :create, :users => {:password => "azerty", :password_confirmation => "azerty"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :users => {:password => "azerty", :password_confirmation => "azerty"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end

    context "missing password" do
      it "doesn't creates user" do
        expect {
          post :create, :users => {:email => "foo@bar.com"}, :format => :json
        }.to change{User.count}.by(0)
      end

      it "returns an error message" do
        post :create, :users => {:email => "foo@bar.com"}, :format => :json
        JSON.parse(response.body)["error"].should_not == nil
      end
    end
  end
end