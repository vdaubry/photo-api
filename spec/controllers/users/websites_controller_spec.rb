require 'rails_helper'

describe Users::WebsitesController do
  login_user
  
  describe "GET index" do
    it "returns user websites" do
      all_websites = FactoryGirl.create_list(:website, 3)
      @user.websites = all_websites[0..1]
      @user.save
      get 'index', :user_id => @user, :format => :json
      JSON.parse(response.body)["websites"].map {|h| h["id"]}.should == @user.websites.map {|w| w.id.to_s}
    end
  end
  
  describe "POST create" do
    context "has no websites" do
      it "adds a website to user" do
        website = FactoryGirl.create(:website)
        post 'create', :user_id => @user, :website_id => website.id, :format => :json
        @user.reload.websites.should == [website]
      end
    end
    
    context "has 1 websites" do
      before(:each) do
        @user.websites = [FactoryGirl.create(:website)]
        @user.save
      end
      
      it "adds a website to user" do
        website2 = FactoryGirl.create(:website)
        post 'create', :user_id => @user, :website_id => website2.id, :format => :json
        @user.reload.websites.count.should == 2
      end
    end
  end
end