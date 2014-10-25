require 'rails_helper'

describe ImagesController do
  let(:website) { FactoryGirl.create(:website) }
  let(:to_sort_post) { FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS, :website => website) }
  let(:sorted_post) { FactoryGirl.create(:post, :status => Post::SORTED_STATUS, :website => website) }
  let(:banished_post) { FactoryGirl.create(:post, :status => Post::SORTED_STATUS, :website => website, :banished => true) }
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

      it "returns 50 images" do
        FactoryGirl.create_list(:image, 50, :post => to_sort_post, :status => Image::TO_SORT_STATUS)
        get 'index', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "status" => Image::TO_SORT_STATUS
        images = JSON.parse(response.body)["images"]
        images.count.should == 50
      end

      it "returns only to_sort_images" do
        to_sort_image
        FactoryGirl.create(:image, :status => Image::KEPT_STATUS, :website => website, :post => to_sort_post)

        get 'index', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "status" => Image::TO_SORT_STATUS

        images = JSON.parse(response.body)["images"]
        images.count.should == 1
        images.first["id"].should == to_sort_image.id.to_s
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

    it "returns image by hosting_url" do
      image = FactoryGirl.create(:image, :website => website, :hosting_url => "www.foo.bar")
      
      get 'search', :format => :json, :website_id => website.id, :hosting_url => "www.foo.bar"

      images = JSON.parse(response.body)["images"]
      images.count.should == 1
      images[0]["hosting_url"].should == "www.foo.bar"
    end

    it "returns images by array of hosting_url" do
      image = FactoryGirl.create(:image, :website => website, :hosting_url => "www.foo.bar")
      image = FactoryGirl.create(:image, :website => website, :hosting_url => "www.foo.bar1")
      
      get 'search', :format => :json, :website_id => website.id, :hosting_urls => ["www.foo.bar","www.foo.bar1"]

      images = JSON.parse(response.body)["images"]
      images.count.should == 2
      images[0]["hosting_url"].should == "www.foo.bar"
      images[1]["hosting_url"].should == "www.foo.bar1"
    end

    it "returns empty images if no image with source_url is found" do
      get 'search', :format => :json, :website_id => website.id, :source_url => "www.foo.bar", :hosting_url => "www.foo.bar"

      images = JSON.parse(response.body)["images"]
      images.count.should == 0
    end

    it "returns empty images if no params is found" do
      get 'search', :format => :json, :website_id => website.id, :source_url => ""

      images = JSON.parse(response.body)["images"]
      images.count.should == 0
    end

    it "returns images by status" do
      img1 = FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS)
      img2 = FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS)
      img3 = FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS)
      
      get 'search', :format => :json, :status => Image::TO_KEEP_STATUS, :page => 1

      images = JSON.parse(response.body)["images"]
      images.count.should == 2
      images[0]["id"].should == img2.id.to_s
      images[1]["id"].should == img3.id.to_s
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

    it "updates updated_at field" do
      image = FactoryGirl.create(:image, :updated_at => DateTime.parse("01/02/2010"), :website => website, :post => to_sort_post)
      put 'update', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => image.id, :format => :js

      image.reload.updated_at.should_not == DateTime.parse("01/02/2010")
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

    it "updates updated_at field" do
      image = FactoryGirl.create(:image, :updated_at => DateTime.parse("01/02/2010"), :website => website, :post => to_sort_post)
      delete 'destroy', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :id => image.id, :format => :js

      image.reload.updated_at.should_not == DateTime.parse("01/02/2010")
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

    it "updates updated_at" do
      image1 = FactoryGirl.create(:image, :updated_at => DateTime.parse("01/02/2010"), :post => to_sort_post, :website => website)
      image2 = FactoryGirl.create(:image, :updated_at => DateTime.parse("01/02/2010"), :post => to_sort_post, :website => website)

      delete 'destroy_all', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, "ids" => [image1.id, image2.id]

      image1.reload.updated_at.should_not == DateTime.parse("01/02/2010")
      image2.reload.updated_at.should_not == DateTime.parse("01/02/2010")
    end

    context "has next post" do
      it "renders next post id" do
        Website.any_instance.stubs(:latest_post_id).returns(to_sort_post.id.to_s)

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

  describe "PUT transfert" do
    it "transfers image" do
      Image.expects(:create_zip).once
      put 'transfert', :format => :json
      response.status.should == 200
    end
  end

  describe "POST create" do
    let(:valid_params) { {:key => "12345_calinours.png", 
      :source_url => "www.foo.bar/img.png", 
      :hosting_url => "www.foo.bar", 
      :status => Image::TO_SORT_STATUS, 
      :image_hash => "AZERTY1234", 
      :width => 400, 
      :height => 400, 
      :file_size => 123678, 
      :scrapped_at => DateTime.parse("20/10/2010")} }

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
        JSON.parse(saved_image.to_json).except("_id", "created_at", "updated_at", "website_id", "post_id").should == {"file_size"=>123678, "height"=>400, "hosting_url"=>"www.foo.bar", "image_hash"=>"AZERTY1234", "key"=>"12345_calinours.png", "scrapped_at" => "2010-10-20T00:00:00.000+00:00", "source_url"=>"www.foo.bar/img.png", "status"=>"TO_SORT_STATUS", "width"=>400}
      end
    end

    context "website doesn't exists" do
      it "doesn't create image" do
        expect {
          post 'create', :format => :json, :website_id => 1234, :post_id => to_sort_post.id, :image => valid_params
          }.to change{Image.count}.by(0)
      end

      it "renders 404" do
        post 'create', :format => :json, :website_id => 1234, :post_id => to_sort_post.id, :image => valid_params
        response.status.should == 404
      end
    end 

    context "post doesn't exists" do
      it "doesn't create image" do
        expect {
          post 'create', :format => :json, :website_id => website.id, :post_id => "1234", :image => valid_params
          }.to change{Image.count}.by(0)
      end

      it "renders 404" do
        post 'create', :format => :json, :website_id => website.id, :post_id => "1234", :image => valid_params
        response.status.should == 404
      end
    end 

    context "post is already sorted" do
      it "updates post status to to_sort" do
        post 'create', :format => :json, :website_id => website.id, :post_id => sorted_post.id, :image => valid_params
        sorted_post.reload.status.should == Post::TO_SORT_STATUS
      end
    end

    context "post is banished" do
      it "updates image status to to_delete" do
        post 'create', :format => :json, :website_id => website.id, :post_id => banished_post.id, :image => valid_params
        banished_post.images.last.status.should == Image::TO_DELETE_STATUS
      end
    end    

    context "invalid image" do
      let(:missing_key) { {:source_url => "www.foo.bar/img.png", :hosting_url => "www.foo.bar", :status => Image::TO_SORT_STATUS, :image_hash => "AZERTY1234", :width => 400, :height => 400, :file_size => 123678, :scrapped_at => DateTime.parse("20/10/2010")} }
      let(:image_too_small) { {:key => "12345_calinours.png", :source_url => "www.foo.bar/img.png", :hosting_url => "www.foo.bar", :status => Image::TO_SORT_STATUS, :image_hash => "AZERTY1234", :width => 200, :height => 400, :file_size => 123678, :scrapped_at => DateTime.parse("20/10/2010")} }

      it "doesn't save images" do
        expect { 
          post 'create', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :image => missing_key 
        }.to change{Image.count}.by(0)
      end
      
      it "saves images even if too small" do
       expect { 
          post 'create', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :image => image_too_small 
        }.to change{Image.count}.by(1)
      end

      it "returns image error" do
        post 'create', :format => :json, :website_id => website.id, :post_id => to_sort_post.id, :image => missing_key

        JSON.parse(response.body).should == {"errors"=>["Key can't be blank"]}
        response.status.should == 422
      end
    end 

  end
end