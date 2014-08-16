require 'rails_helper'

describe PostCleaner do
  describe "perform" do

    context "post with images to sort" do
      it "doesn't change post status" do
        post_with_images = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
        FactoryGirl.create(:image, :post => post_with_images, :status => Image::TO_SORT_STATUS)

        PostCleaner.perform

        Post.to_sort.count.should == 1
        Post.to_sort.to_a.should == [post_with_images]
      end
    end

    context "post without images" do
      it "sets to sorted status" do
        post_without_images = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
        
        PostCleaner.perform

        Post.to_sort.count.should == 0
      end
    end

    context "post with images already sorted" do
      it "sets to sorted status" do
        post_with_images = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
        FactoryGirl.create(:image, :post => post_with_images, :status => Image::KEPT_STATUS)

        PostCleaner.perform

        Post.to_sort.count.should == 0
      end
    end
  end
end