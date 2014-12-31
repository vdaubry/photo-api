require 'rails_helper'

describe PostSerializer do

  it "serializes a post" do
    post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
    serializer = PostSerializer.new post
    expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","images_count":0,"favorite_count":0}}')
  end
  
  it "serializes a post with current_page" do
    post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
    serializer = PostSerializer.new post, :current_page => 2
    expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","current_page":2,"images_count":0,"favorite_count":0}}')
  end

  context "user not logged in" do
    before(:each) do
      @post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
      FactoryGirl.create_list(:image, 2, :post => @post)
    end
    
    it "serializes a post with number of images" do
      serializer = PostSerializer.new @post, :current_page => 2
      expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","current_page":2,"images_count":2,"favorite_count":0}}')
    end
    
    it "returns 0 favorite images" do
      
    end
  end
  
  context "user logged in" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    context "user has visited post" do
      it "serializes a post with number of images left to see" do
        post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
        FactoryGirl.create_list(:image, 2, :post => post)
        FactoryGirl.create(:user_post, :post => post, :user => @user, :images_seen_count => 1)
        serializer = PostSerializer.new post, {:current_page => 2, :current_user => @user}
        expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","current_page":2,"images_count":1,"favorite_count":0}}')
      end
    end
    
    context "user has never visited post" do
      it "serializes a post with number of images left to see" do
        post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
        FactoryGirl.create_list(:image, 2, :post => post)
        serializer = PostSerializer.new post, {:current_page => 2, :current_user => @user}
        expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","current_page":2,"images_count":2,"favorite_count":0}}')
      end
    end
  end
end