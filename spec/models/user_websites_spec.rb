require "rails_helper"

describe UserWebsite do
  describe "create" do

    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }

    context "valid user_websites" do
      it { FactoryGirl.build(:user_website).save.should == true }
    end

    context "duplicate user_websites url" do
      it { 
        FactoryGirl.build(:user_website, :user => user, :url => "http://www.foo.bar").save.should == true 
        FactoryGirl.build(:user_website, :user => user, :url => "http://www.foo.bar").save.should == false 
      }
    end

    context "same user_websites url but different users" do
      it { 
        FactoryGirl.build(:user_website, :user => user, :url => "http://www.foo.bar").save.should == true 
        FactoryGirl.build(:user_website, :user => user2, :url => "http://www.foo.bar").save.should == true
      }
    end

    context "duplicate user_websites name" do
      it { 
        FactoryGirl.build(:user_website, :user => user, :name => "foobar").save.should == true 
        FactoryGirl.build(:user_website, :user => user, :name => "foobar").save.should == false 
      }
    end

    context "same user_websites name but different users" do
      it { 
        FactoryGirl.build(:user_website, :user => user, :name => "foobar").save.should == true 
        FactoryGirl.build(:user_website, :user => user2, :name => "foobar").save.should == true
      }
    end

    context "duplicate user_websites website_id" do
      it { 
        FactoryGirl.build(:user_website, :user => user, :website_id => "5401aeda4d616307e1030000").save.should == true 
        FactoryGirl.build(:user_website, :user => user, :website_id => "5401aeda4d616307e1030000").save.should == false 
      }
    end

    context "has embedded posts" do
      it "associates website_posts to user_website" do
        user_website = FactoryGirl.create(:user_website)
        FactoryGirl.create_list(:website_post, 2, :user_website => user_website)

        user_website.website_posts.count.should == 2
        User.first.user_websites.first.website_posts.count.should == 2
      end
    end
  end

  describe "update_posts" do
    before(:each) do
      website = FactoryGirl.create(:website)
      website.posts = FactoryGirl.create_list(:post, 2)
      @user_website = FactoryGirl.create(:user_website, :website_id => website.id)
    end

    it "adds website posts" do
      @user_website.update_posts
      User.find(@user_website.user.id).user_websites.first.website_posts.count.should == 2
    end

    it "calls set images on each post" do
      WebsitePost.any_instance.expects(:update_images).times(2)
      @user_website.update_posts
    end
  end
end