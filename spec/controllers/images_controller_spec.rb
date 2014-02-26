require 'spec_helper'

describe ImagesController do
  let(:website) { FactoryGirl.create(:website) }
  let(:to_sort_post) { FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS, :website => website) }
  let(:to_sort_image) { FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS, :website => website, :post => to_sort_post) }

  describe "GET index" do
    it "sets counters" do
      to_sort_image
      image = FactoryGirl.create(:image, :website => website, :status => Image::TO_SORT_STATUS)
      image = FactoryGirl.create(:image, :website => website, :status => Image::TO_KEEP_STATUS)

      get 'index', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "status" => Image::TO_SORT_STATUS

      resp = JSON.parse(response.body)["meta"]
      resp["to_sort_count"].should == 2
      resp["to_keep_count"].should == 1
      resp["to_delete_count"].should == 0
    end
    
    context "to sort images" do
      it "returns latest post images" do
        to_sort_post2 = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS, :name => "post2", :website => website)
        
        image = FactoryGirl.create(:image, :post => to_sort_post2, :status => Image::TO_SORT_STATUS)

        get 'index', :format => :json, :website_id => website.id, :post_id => to_sort_post2.id, "status" => Image::TO_SORT_STATUS

        images = JSON.parse(response.body)["images"]
        images.count.should == 1
        images.first["id"].should == image.id.to_s
      end
    end

    context "to keep images" do
      it "returns website images" do
        image = FactoryGirl.create(:image, :website => website, :status => Image::TO_KEEP_STATUS)
        image2 = FactoryGirl.create(:image, :post => to_sort_post, :status => Image::TO_KEEP_STATUS)

        get 'index', :format => :json, :website_id => website.id, "status" => Image::TO_KEEP_STATUS

        images = JSON.parse(response.body)["images"]
        images.count.should == 1
        images.first["id"].should == image.id.to_s
      end
    end

    context "to delete images" do
      it "returns website images" do
        image = FactoryGirl.create(:image, :website => website, :status => Image::TO_DELETE_STATUS)
        image2 = FactoryGirl.create(:image, :post => to_sort_post, :status => Image::TO_DELETE_STATUS)

        get 'index', :format => :json, :website_id => website.id, "status" => Image::TO_DELETE_STATUS

        images = JSON.parse(response.body)["images"]
        images.count.should == 1
        images.first["id"].should == image.id.to_s
      end
    end
  end

  describe "PUT update" do
    it "updates image status to keep status" do
      put 'update', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => to_sort_image.id, :format => :js

      to_sort_image.reload.status.should == Image::TO_KEEP_STATUS
    end 

    it "calls check status" do
      Post.any_instance.expects(:check_status!).once

      put 'update', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => to_sort_image.id, :format => :js
    end
  end

  describe "DELETE destroy" do
    it "updates image status to delete status" do
      delete 'destroy', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => to_sort_image.id, :format => :js

      to_sort_image.reload.status.should == Image::TO_DELETE_STATUS
    end

    it "calls check status" do
      Post.any_instance.expects(:check_status!).once

      delete 'destroy', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => to_sort_image.id, :format => :js
    end
  end 

  describe "DELETE destroy_all" do
    it "updates image status to delete status" do
      image2 = FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS, :post => to_sort_post, :website => website)

      delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "image" => {"ids" => [to_sort_image.id]}

      to_sort_image.reload.status.should == Image::TO_DELETE_STATUS
      image2.reload.status.should == Image::TO_SORT_STATUS
    end

    it "calls check status of post" do
      Post.any_instance.expects(:check_status!).once

      delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "image" => {"ids" => [to_sort_image.id]}
    end

    context "has next post" do
      it "renders next post id" do
        Website.any_instance.stubs(:latest_post).returns(to_sort_post)

        delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "image" => {"ids" => [to_sort_image.id]}

        JSON.parse(response.body)["next_post_id"].should == to_sort_post.id.to_s
      end
    end

    context "no next post" do
      it "renders nil" do
        Website.any_instance.stubs(:latest_post).returns(nil)

        delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "image" => {"ids" => [to_sort_image.id]}

        JSON.parse(response.body)["next_post_id"].should == nil
      end
    end
  end

  describe "PUT redownload" do
    it "redownloads image" do
      Image.any_instance.expects(:download).once

      put 'redownload', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => to_sort_image.id, :format => :js
    end
  end
end