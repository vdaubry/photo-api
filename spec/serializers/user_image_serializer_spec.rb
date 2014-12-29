require 'rails_helper'

describe UserImageSerializer do
  it "serializes images" do
    website = FactoryGirl.create(:website)
    post = FactoryGirl.create(:post)
    image = FactoryGirl.create(:image)
    user_image = UserImage.create(:image => image, :website => website, :post => post)
    
    serializer = ActiveModel::ArraySerializer.new([user_image], each_serializer: UserImageSerializer, root: "user_images")

    expect(serializer.to_json).to eql("{\"user_images\":[{\"image_id\":\"#{image.id}\"}]}")
  end
end