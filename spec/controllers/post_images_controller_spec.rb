require 'rails_helper'

describe PostImagesController do
  let(:user) { FactoryGirl.create(:user, :email => "foo@bar.com", :authentication_token => "foobar") }
  let(:user_website) { FactoryGirl.create(:user_website, :user => user) }
  let(:to_sort_post) { FactoryGirl.create(:website_post, :status => Post::TO_SORT_STATUS, :user_website => user_website) }
  let(:sorted_post) { FactoryGirl.create(:website_post, :status => Post::SORTED_STATUS, :user_website => user_website) }
  let(:to_sort_image) { FactoryGirl.create(:post_image, :status => Image::TO_SORT_STATUS, :website_post => to_sort_post) }

  describe "GET index" do
    it "returns images form first post unsorted" do
      to_sort_image
      get :index, :user_website_id => user_website.id.to_s, :website_post_id => to_sort_post.id.to_s, :token => "foobar", :format => :json
      resp = JSON.parse(response.body)
      resp["post_images"].first["fullsize_url"].should_not == nil
      resp["post_images"].first["id"].should_not == nil
      resp["post_images"].first["thumbnail_url"].should_not == nil
    end

    it "returns 404 if website doesn't exist" do
      to_sort_image
      get :index, :user_website_id => "foo", :website_post_id => to_sort_post.id.to_s, :token => "foobar", :format => :json
      response.code.should == "404"
    end
  end
end