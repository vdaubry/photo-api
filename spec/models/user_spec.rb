require "rails_helper"

describe User do
  describe "save" do
    context "valid" do
      it  { FactoryGirl.build(:user).save.should == true }
    end

    context "duplicates email" do
      it  { 
        FactoryGirl.build(:user, :email => "email@email.com").save.should == true 
        FactoryGirl.build(:user, :email => "email@email.com").save.should == false 
      }
    end

    context "duplicates authentication_token" do
      it  { 
        FactoryGirl.build(:user, :authentication_token => "string").save.should == true 
        FactoryGirl.build(:user, :authentication_token => "string").save.should == false 
      }
    end

    context "new user with empty authentication_token" do
      it "assigns a new authentication_token" do
        user = FactoryGirl.build(:user, :authentication_token => nil)
        user.save
        user.authentication_token.should_not == nil
      end
    end

    context "new user with authentication_token" do
      it "doesn't change authentication_token" do
        user = FactoryGirl.build(:user, :authentication_token => "string1")
        user.save
        user.authentication_token.should == "string1"
      end
    end
  end
end