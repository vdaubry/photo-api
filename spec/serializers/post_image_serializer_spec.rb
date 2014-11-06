require 'rails_helper'

describe PostImageSerializer do

  it "serializes an image" do
    image = FactoryGirl.create(:post_image, :key => "some_key", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = PostImageSerializer.new image

    result = JSON.parse(serializer.to_json)["post_image"]
    result["id"].should == "506144650ed4c08d84000001"
    result["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true
  end

  it "serializes an array of images" do
    images = FactoryGirl.build_list(:post_image, 2, :key => "some_key", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = ActiveModel::ArraySerializer.new(images, each_serializer: PostImageSerializer)

    results = JSON.parse(serializer.to_json)
    results.count.should == 2

    result1 = results.first
    result1["id"].should == "506144650ed4c08d84000001"
    result1["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result1["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true

    result2 = results.second
    result2["id"].should == "506144650ed4c08d84000001"
    result2["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result2["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true
  end
end