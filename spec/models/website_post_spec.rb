require "rails_helper"

describe WebsitePost do
  describe "create" do
    context "valid website_post" do
      it { FactoryGirl.build(:website_post).save.should == true }
    end
  end

  describe "update_images" do
    let(:post) { FactoryGirl.create(:post) }
    let(:website_post) { FactoryGirl.create(:website_post, :post_id => post.id) }

    it "creates post_images" do
      post.images = FactoryGirl.create_list(:image, 2)
      
      website_post.update_images

      User.first.user_websites.first.website_posts.first.post_images.count.should == 2
    end

    context "has already images" do
      it "adds only new images" do
        image1 = FactoryGirl.create(:image, :post => post)
        image2 = FactoryGirl.create(:image, :post => post)
        website_post.post_images = [FactoryGirl.create(:post_image, :key => image1.key)]

        website_post.update_images

        website_post.post_images.map(&:key).should == [image1.key, image2.key]
      end
    end
  end
end