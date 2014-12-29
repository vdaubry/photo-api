require 'rails_helper'

describe ImageSerializer do

  it "serializes an image" do
    image = FactoryGirl.create(:image, :key => "some_key", :width => 500, :height => 300, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'), :source_url => "www.foo.bar", :hosting_url => "www.bar.foo")
    serializer = ImageSerializer.new image

    result = JSON.parse(serializer.to_json)["image"]
    result["id"].should == "506144650ed4c08d84000001"
    result["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true
    result["width"].should == 500
    result["height"].should == 300
  end

  it "serializes an array of images" do
    images = FactoryGirl.build_list(:image, 2, :key => "some_key", :width => 500, :height => 300, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'), :source_url => "www.foo.bar", :hosting_url => "www.bar.foo")
    serializer = ActiveModel::ArraySerializer.new(images, each_serializer: ImageSerializer)

    results = JSON.parse(serializer.to_json)
    results.count.should == 2

    result1 = results.first
    result1["id"].should == "506144650ed4c08d84000001"
    result1["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result1["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true
    result1["width"].should == 500
    result1["height"].should == 300

    result2 = results.second
    result2["id"].should == "506144650ed4c08d84000001"
    result2["thumbnail_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/0/0/0/some_key?AWSAccessKeyId").should == true
    result2["fullsize_url"].include?("https://photovisualizer-dev.s3.amazonaws.com/image/0/0/0/some_key?AWSAccessKeyId").should == true
    result2["width"].should == 500
    result2["height"].should == 300
  end
end