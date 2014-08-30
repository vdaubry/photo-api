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

  describe "follow_website" do
    let(:user) { FactoryGirl.create(:user) }
    it "adds a user_website to the user" do
      website = FactoryGirl.create(:website, :name => "foo", :url => "http://www.foo.bar")
      user.follow_website(website)

      user_website = User.find(user.id).user_websites.first
      user_website.website_id.should == website.id.to_s
      user_website.name.should == "foo"
      user_website.url.should == "http://www.foo.bar"
    end

    context "already following website" do
      it "ignores website" do
        website = FactoryGirl.create(:website)
        uw = FactoryGirl.create(:user_website, :user => user, :website_id => website.id)
        user.user_websites = [uw]

        user.follow_website(website)
        user.user_websites.should == [uw]
      end
    end
    
  end

  describe "update_websites" do
    it "calls update on each post" do
      user = FactoryGirl.create(:user)
      user.user_websites = FactoryGirl.create_list(:user_website, 2, :user => user)
      UserWebsite.any_instance.expects(:update_posts).times(2)
      user.update_websites
    end
  end
end