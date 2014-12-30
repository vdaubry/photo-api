require 'rails_helper'

describe PostSerializer do

  it "serializes a post" do
    post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
    serializer = PostSerializer.new post
    expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar"}}')
  end
  
  it "serializes a post with current_page" do
    post = FactoryGirl.create(:post, :id => "5314e4264d6163063f020000", :name => "some_name", :source_url => "http://www.foo.bar")
    serializer = PostSerializer.new post, :current_page => 2
    expect(serializer.to_json).to eql('{"post":{"id":"5314e4264d6163063f020000","name":"some_name","source_url":"http://www.foo.bar","current_page":2}}')
  end

end