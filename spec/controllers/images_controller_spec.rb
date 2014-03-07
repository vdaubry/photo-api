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

  describe "GET search" do
    it "returns image by source_url" do
      image = FactoryGirl.create(:image, :website => website, :source_url => "www.foo.bar")
      
      get 'search', :format => :json, :website_id => website.id, :source_url => "www.foo.bar"

      images = JSON.parse(response.body)["images"]
      images.count.should == 1
      images[0]["source_url"].should == "www.foo.bar"
    end

    it "returns nil if no image with source_url is found" do
      get 'search', :format => :json, :website_id => website.id, :source_url => "www.foo.bar"

      images = JSON.parse(response.body)["images"]
      images.count.should == 0
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

      delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "ids" => [to_sort_image.id]

      to_sort_image.reload.status.should == Image::TO_DELETE_STATUS
      image2.reload.status.should == Image::TO_SORT_STATUS
    end

    it "calls check status of post" do
      Post.any_instance.expects(:check_status!).once

      delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "ids" => [to_sort_image.id]
    end

    context "has next post" do
      it "renders next post id" do
        Website.any_instance.stubs(:latest_post).returns(to_sort_post)

        delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "ids" => [to_sort_image.id]

        JSON.parse(response.body)["next_post_id"].should == to_sort_post.id.to_s
      end
    end

    context "no next post" do
      it "renders nil" do
        Website.any_instance.stubs(:latest_post).returns(nil)

        delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "ids" => [to_sort_image.id]

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

  describe "POST create" do
    let(:valid_params) { {:key => "12345_calinours.png", :source_url => "www.foo.bar/img.png", :hosting_url => "www.foo.bar", :status => Image::TO_SORT_STATUS, :image_hash => "AZERTY1234", :width => 400, :height => 400, :file_size => 123678} }

    context "valid params" do
      it "creates an image" do
        expect {
          post 'create', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :image => valid_params
        }.to change{Image.count}.by(1)
      end

      it "sets image attributes" do
        post 'create', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :image => valid_params

        saved_image = Image.last
        saved_image.website.should == website
        saved_image.post.should == to_sort_post
        JSON.parse(saved_image.to_json).except("_id", "created_at", "updated_at", "website_id", "post_id").should == {"file_size"=>123678, "height"=>400, "hosting_url"=>"www.foo.bar", "image_hash"=>"AZERTY1234", "key"=>"12345_calinours.png", "source_url"=>"www.foo.bar/img.png", "status"=>"TO_SORT_STATUS", "width"=>400}
      end
    end

  #   context "website doesn't exists" do
  #     it "doesn't create post" do
  #       expect {
  #         post 'create', :format => :json, :website_id => 1234, :post => {:name => "toto_11/22"}
  #         }.to change{Post.count}.by(0)
  #     end

  #     it "renders 404" do
  #       post 'create', :format => :json, :website_id => 1234, :post => {:name => "toto_11/22"}
  #       response.status.should == 404
  #     end
  #   end 

  #   context "invalid post" do
  #     let(:website) { FactoryGirl.create(:website) }

  #     it "doesn't create post" do
  #       expect {
  #         post 'create', :format => :json, :website_id => website.id, :name => "toto_11/22"
  #         }.to change{Post.count}.by(0)
  #     end
  #   end 

  #   context "Post already exists for same website" do
  #     let(:website) { FactoryGirl.create(:website) }

  #     it "doesn't create post" do
  #       FactoryGirl.create(:post, :website => website, :name => "toto_11/22")
  #       expect {
  #         post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}
  #         }.to change{Post.count}.by(0)
  #     end
  #   end

  #   context "Post already exists for another website" do
  #     let(:website) { FactoryGirl.create(:website) }

  #     it "creates post" do
  #       FactoryGirl.create(:post, :name => "toto_11/22")
  #       expect {
  #         post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}
  #         }.to change{Post.count}.by(1)
  #     end
  #   end
  end
end