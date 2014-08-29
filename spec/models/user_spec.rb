require "rails_helper"

describe User do
  describe "save" do
    context "valid" do
      it  { FactoryGirl.build(:user).save.should == true }
    end

    context "missing email" do
      it  { FactoryGirl.build(:user, :email => nil).save.should == false }
    end

  context "missing authentication_token" do
      it  { FactoryGirl.build(:user, :authentication_token => nil).save.should == true }
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

    context "has user_websites" do
      it {
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:user_website, :user => user)
        FactoryGirl.create(:user_website, :user => user)

        user.user_websites.count.should == 2
        User.first.user_websites.count.should == 2
      }
    end
  end

  describe "assign_authentication_token!" do
    it "assigns a new authentication_token" do
      user = FactoryGirl.build(:user, :authentication_token => nil)
      user.assign_authentication_token!
      User.find(user.id).authentication_token.should_not == nil
    end

    context "duplicates authentication_token" do
      it "assigns another authentication_token" do
        SecureRandom.stub_chain(:urlsafe_base64, :tr).returns("azerty").then.returns("azerty2")

        FactoryGirl.create(:user, :authentication_token => "azerty")
        user = FactoryGirl.build(:user)
        user.assign_authentication_token!
        User.find(user.id).authentication_token.should == "azerty2"
      end
    end
  end


  describe "user posts relation" do
    context "2 users have same posts" do
      it "saves 2 different status for same post" do
        
      end
    end
  end
end