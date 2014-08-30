require "rails_helper"

describe WebsitePost do
  describe "create" do
    context "valid website_post" do
      it { FactoryGirl.build(:website_post).save.should == true }
    end
  end

  describe "update_images" do
    it "creates post_images" do
      post = FactoryGirl.create(:post)
      post.images = FactoryGirl.create_list(:image, 2)
      website_post = FactoryGirl.create(:website_post, :post_id => post.id)

      website_post.update_images

      User.first.user_websites.first.website_posts.first.post_images.count.should == 2
    end
  end
end