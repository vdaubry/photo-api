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
      @website = FactoryGirl.create(:website)
      @post1 = FactoryGirl.create(:post, :website => @website)
      @post2 = FactoryGirl.create(:post, :website => @website)
      @user_website = FactoryGirl.create(:user_website, :website_id => @website.id)
    end

    it "adds website posts" do
      @user_website.update_posts
      User.find(@user_website.user.id).user_websites.first.website_posts.count.should == 2
    end

    it "calls set images on each post" do
      WebsitePost.any_instance.expects(:update_images).times(2)
      @user_website.update_posts
    end

    context "post already added" do
      it "adds only new post" do
        @user_website.website_posts = [FactoryGirl.create(:website_post, :post_id => @post1.id)]
        @user_website.update_posts
        @user_website.website_posts.map(&:post_id).should == [@post1.id.to_s, @post2.id.to_s]
      end
    end

    describe "max posts limit" do
      before(:each) do
        UserWebsite.send(:remove_const, :MAX_POSTS)
      end

      context "has less than max posts" do
        it "adds all posts" do
          UserWebsite.const_set(:MAX_POSTS, 2)
          @user_website.update_posts
          @user_website.website_posts.count.should == 2
        end
      end

      context "has more than max posts" do
        it "adds only posts that are below max" do
          UserWebsite.const_set(:MAX_POSTS, 1)
          @user_website.update_posts
          @user_website.website_posts.count.should == 1
        end
      end

      context "post already added with more than 1000 posts" do
        it "doesn't add posts" do
          UserWebsite.const_set(:MAX_POSTS, 1)
          @user_website.website_posts = [FactoryGirl.create(:website_post, :post_id => @post1.id)]
          @user_website.update_posts
          #@user_website.website_posts.count.should == 1

          #voir comment stubber le max 1000 posts : https://github.com/freerange/mocha/issues/13
          #todo : idem sur website_posts, si il y a plus de 1000 images, n'ajouter que les nouvelles images en deca des 1000
        end
      end 
    end
    



    
  end
end