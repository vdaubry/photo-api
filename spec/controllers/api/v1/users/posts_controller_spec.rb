require 'rails_helper'

describe Api::V1::Users::PostsController do
  login_user
  
  let(:website) {FactoryGirl.create(:website)}
  let(:post) {FactoryGirl.create(:post, :website => website)} 
    
  describe "GET index" do
    it "returns all posts" do
      post1 = FactoryGirl.create(:post, :website => website)
      post2 = FactoryGirl.create(:post, :website => website)
      
      get 'index', :format => :json, :website_id => website.id, :user_id => @user.id
      
      JSON.parse(response.body)["posts"].count.should == 2
    end
  end
  
  describe "GET show" do
    context "first time user visits post" do
      it "returns post with current page = 0" do
        get 'show', :format => :json, :id => post.id, :website_id => website.id, :user_id => @user.id
        
        JSON.parse(response.body)["posts"]["current_page"].should == 1
      end
    end
    
    context "user already visited post" do
      it "returns post with current page = 4" do
        FactoryGirl.create(:user_post, :user => @user, :website => website, :post => post, :current_page => 4)
        get 'show', :format => :json, :id => post.id, :website_id => website.id, :user_id => @user.id
      
        JSON.parse(response.body)["posts"]["current_page"].should == 4
      end
    end
    
    context "get latest post" do
      it "returns lastest updated post" do
        post1 = FactoryGirl.create(:post, :website => website, :updated_at => Date.parse("01/01/2011"))
        post2 = FactoryGirl.create(:post, :website => website, :updated_at => Date.parse("01/01/2010"))
        
        get 'show', :format => :json, :id => "latest", :website_id => website.id, :user_id => @user.id
        
        JSON.parse(response.body)["posts"]["id"].should_not == post2.id.to_s
      end
    end
  end
  
  describe "PUT update" do
    it "sets post current page" do
      put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => {:current_page => 3}
      
      @user.reload.user_posts.where(:post => post.id).first.current_page.should == 3
    end
    
    context "first time user sees page" do
      before(:each) do
        @user_post = UserPost.create(:website => website, 
          :post => post, 
          :user => @user, 
          :current_page => 3, 
          :pages_seen => [], 
          :images_seen_count => 52)
      end
      
      it "adds current page to pages seen" do
        put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => { :current_page => 3, :images_seen => 50}
        @user_post.reload.pages_seen.should == [3]
      end
      
      it "adds current page to pages seen" do
        put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => { :current_page => 3, :images_seen => 50}
        @user_post.reload.images_seen_count.should == 102
      end
      
      it "returns post" do
        put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => { :current_page => 3, :images_seen => 50}
        
        JSON.parse(response.body)["posts"].should_not == nil
      end
    end
    
    context "second time user sees page" do
      before(:each) do
        @user_post = UserPost.create(:website => website, 
          :post => post, 
          :user => @user, 
          :current_page => 3, 
          :pages_seen => [3], 
          :images_seen_count => 52)
      end
      
      it "doesn't add duplicate page to pages seen" do
        put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => {:current_page => 3, :images_seen => 50}
        
        @user_post.reload.pages_seen.should == [3]
      end
      
      it "doesn't increase images_seen_count" do
        put 'update', :format => :json, :website_id => website.id, :id => post.id, :user_id => @user.id, :post => {:current_page => 3, :images_seen => 50}
        
        @user_post.reload.images_seen_count.should == 52
      end
    end
  end
  
end