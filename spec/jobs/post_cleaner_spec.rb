require 'spec_helper'

describe PostCleaner do
  describe "perform" do
    it "sets all post without images to sorted status" do
      post_with_images = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
      post_wihtout_images = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
      FactoryGirl.create(:image, :post => post_with_images)
      Post.to_sort.count.should == 2
      post_with_images.images.count.should == 1

      PostCleaner.perform

      Post.to_sort.count.should == 1
      Post.to_sort.to_a.should == [post_with_images]
    end
  end
end