require 'spec_helper'

describe ImageSerializer do

  it "serializes an image" do
    image = FactoryGirl.create(:image, :key => "some_key", :width => 200, :height => 300, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = ImageSerializer.new image

    expect(serializer.to_json).to eql('{"image":{"id":"506144650ed4c08d84000001","key":"some_key","width":200,"height":300}}')
  end

  it "serializes an array of images" do
    images = FactoryGirl.build_list(:image, 2, :key => "some_key", :width => 200, :height => 300, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = ActiveModel::ArraySerializer.new(images, each_serializer: ImageSerializer)

    expect(serializer.to_json).to eql('[{"id":"506144650ed4c08d84000001","key":"some_key","width":200,"height":300},{"id":"506144650ed4c08d84000001","key":"some_key","width":200,"height":300}]')
  end
end