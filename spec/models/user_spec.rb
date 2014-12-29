require "rails_helper"

describe User do
  
  let(:user) { FactoryGirl.create(:user) }
  
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

    context "has websites" do
      it {
        user.websites = FactoryGirl.create_list(:website, 2)
        user.save!

        User.first.websites.count.should == 2
      }
      
      it "forbids duplicates websites" do
        website = FactoryGirl.create(:website)
        user.websites = [website]
        user.websites << website
        user.save
        user.reload.websites.count.should == 1
      end
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
end