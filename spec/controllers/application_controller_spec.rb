require 'rails_helper'

describe ApplicationController do
  describe "GET ping" do

    context "finds website" do
      it "returns ok if it finds a website" do
        FactoryGirl.create(:website)
        get :ping
        response.body.should == "ok"
      end
    end

    context "no website" do
      it "returns not found" do
        get :ping
        response.body.should == "not found"
      end
    end

    context "mongdb not available" do
      it "returns not found" do
        Website.stubs(:first).raises(Moped::Errors::OperationFailure.new("command", {:details => "nope"}))
        expect {get :ping}.to raise_error(Moped::Errors::OperationFailure)
      end
    end    
  end
end
 