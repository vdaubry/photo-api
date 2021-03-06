require 'rails_helper'

describe PostsController do
  let(:website) { FactoryGirl.create(:website) }
  let(:to_sort_post) { FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS, :website => website) }
  let(:next_post) { FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS, :website => website) }

  describe "DELETE destroy" do  
    context "has next post" do
      it "sets all remaining images to delete_status" do
        FactoryGirl.create_list(:image, 2, :post => to_sort_post, :status => Image::TO_SORT_STATUS)
        FactoryGirl.create_list(:image, 2, :post => to_sort_post, :status => Image::TO_KEEP_STATUS)

        delete 'destroy', :id => to_sort_post.id, :website_id => website.id

        to_sort_post.images.where(:status => Image::TO_SORT_STATUS).count.should == 0
        to_sort_post.images.where(:status => Image::TO_DELETE_STATUS).count.should == 2
        to_sort_post.images.where(:status => Image::TO_KEEP_STATUS).count.should == 2
      end

      it "sets post to sorted" do
        delete 'destroy', :id => to_sort_post.id, :website_id => website.id

        to_sort_post.reload.status.should == Post::SORTED_STATUS
      end

      it "renders next post" do
        next_post

        delete 'destroy', :id => to_sort_post.id, :website_id => website.id

        JSON.parse(response.body).should == {"latest_post"=> next_post.id.to_s}
      end
    end

    context "no more posts" do
      it "renders null" do
        delete 'destroy', :id => to_sort_post.id, :website_id => website.id

        JSON.parse(response.body).should == {"latest_post" => nil}
      end
    end
  end

  describe "POST create" do
    context "valid params" do
      it "creates a post" do
        expect {
          post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}
        }.to change{Post.count}.by(1)
      end

      it "sets existing posts to unsorted status" do
        post = FactoryGirl.create(:post, :status =>  Post::SORTED_STATUS, :website => website, :name => "toto_11/22")
        post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}

        post.reload.status.should == Post::TO_SORT_STATUS
      end

      it "sets post attributes" do
        post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}

        Post.last.website.should == website
        Post.last.name.should == "toto_11/22"
      end
    end

    context "website doesn't exists" do
      it "doesn't create post" do
        expect {
          post 'create', :format => :json, :website_id => 1234, :post => {:name => "toto_11/22"}
          }.to change{Post.count}.by(0)
      end

      it "renders 404" do
        post 'create', :format => :json, :website_id => 1234, :post => {:name => "toto_11/22"}
        response.status.should == 404
      end
    end 

    context "invalid post" do
      it "doesn't create post" do
        expect {
          post 'create', :format => :json, :website_id => website.id, :name => "toto_11/22"
          }.to change{Post.count}.by(0)
      end
    end 

    context "Post already exists for same website" do
      it "doesn't create post" do
        FactoryGirl.create(:post, :website => website, :name => "toto_11/22")
        expect {
          post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}
          }.to change{Post.count}.by(0)
      end
    end

    context "Post already exists for another website" do
      it "creates post" do
        FactoryGirl.create(:post, :name => "toto_11/22")
        expect {
          post 'create', :format => :json, :website_id => website.id, :post => {:name => "toto_11/22"}
          }.to change{Post.count}.by(1)
      end
    end
  end

  describe "GET search" do
    it "returns posts" do
      FactoryGirl.create(:post, :website => website, :pages_url => ["www.foo.bar","www.foo.bar1","www.foo.bar2"], :name => "toto_11/22")

      get 'search', :format => :json, :website_id => website.id, :page_url => "www.foo.bar"

      posts = JSON.parse(response.body)["posts"]
      posts.count.should == 1
      posts[0]["name"].should == "toto_11/22"
    end

    it "doesn't return post not mathcing url" do
      FactoryGirl.create(:post, :website => website, :pages_url => ["www.foo.bar","www.foo.bar1","www.foo.bar2"], :name => "post1")
      FactoryGirl.create(:post, :website => website, :pages_url => ["www.foo.bar1","www.foo.bar2"], :name => "post2")
      FactoryGirl.create(:post, :pages_url => ["www.foo.bar","www.foo.bar1","www.foo.bar2"], :name => "post3")

      get 'search', :format => :json, :website_id => website.id, :page_url => "www.foo.bar"

      posts = JSON.parse(response.body)["posts"]
      posts.count.should == 1
      posts[0]["name"].should == "post1"
    end
  end

  describe "PUT update" do
    it "adds page_url to post" do
      post = FactoryGirl.create(:post, :website => website, :pages_url => ["www.foo.bar1","www.foo.bar2"], :name => "toto_11/22")

      put 'update', :format => :json, :website_id => website.id, :id => post.id, :post => {:page_url => "www.foo.bar"}

      post.reload.pages_url.should =~ ["www.foo.bar","www.foo.bar1","www.foo.bar2"]
    end

    it "returns post" do
      post = FactoryGirl.create(:post, :website => website, :pages_url => ["www.foo.bar","www.foo.bar1","www.foo.bar2"], :name => "toto_11/22")

      put 'update', :format => :json, :website_id => website.id, :id => post.id, :post => {:page_url => "www.foo.bar"}

      post = JSON.parse(response.body)["post"]
      post["name"].should == "toto_11/22"
    end
  end

  describe "PUT banish" do
    it "sets post to banished" do
      put 'banish', :format => :json, :website_id => website.id, :id => to_sort_post.id

      to_sort_post.reload.banished.should == true
    end

    it "renders next post" do
      next_post

      put 'banish', :format => :json, :website_id => website.id, :id => to_sort_post.id

      JSON.parse(response.body).should == {"latest_post"=> next_post.id.to_s}
    end
  end
end