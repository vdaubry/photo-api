require 'rails_helper'

describe Api::V1::Users::ImagesController do
  login_user
  
  let(:post) {FactoryGirl.create(:post)}
    
  describe "GET index" do
    
    it "returns post images ordered by scrapping date" do
      img1 = FactoryGirl.create(:image, :post => post, :scrapped_at => Date.parse("01/01/2010"))
      img2 = FactoryGirl.create(:image, :post => post, :scrapped_at => Date.parse("01/01/2009"))
      @user.user_images = [UserImage.create(:image => img1, :post => post), UserImage.create(:image => img2, :post => post)]
      
      get 'index', :format => :json, :post_id => post.id, :user_id => @user.id
      
      JSON.parse(response.body)["images"].count.should == 2
      JSON.parse(response.body)["images"][0]["id"].should == img2.id.to_s
    end
  end
  
  describe "PUT update" do
    it "saves user image" do
      image = FactoryGirl.create(:image, :post => post, :scrapped_at => Date.parse("01/01/2010"))
      put 'update', :format => :json, :post_id => post.id, :user_id => @user.id, :id => image.id
      @user.reload.user_images.first.image_id.should == image.id
    end
  end
  
end