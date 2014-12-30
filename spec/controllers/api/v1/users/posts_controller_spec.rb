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
        get 'show', :format => :json, :id => post.id, :user_id => @user.id
        
        JSON.parse(response.body)["posts"]["current_page"].should == 1
      end
    end
    
    context "user already visited post" do
      it "returns post with current page = 4" do
        @user.user_posts = [UserPost.create(:website => website, :post => post, :current_page => 4)]
        get 'show', :format => :json, :id => post.id, :user_id => @user.id
        
        JSON.parse(response.body)["posts"]["current_page"].should == 4
      end
    end
  end
  
end