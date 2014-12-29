require 'rails_helper'

describe WebsiteSerializer do

  it "serializes a website" do
    website = FactoryGirl.create(:website, :url => "some url", :name => "some name", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = WebsiteSerializer.new website

    expect(serializer.to_json).to eql('{"website":{"id":"506144650ed4c08d84000001","name":"some name","url":"some url"}}')
  end

  it "serializes an array of websites" do
    websites = FactoryGirl.build_list(:website, 2, :url => "some url", :name => "some name", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = ActiveModel::ArraySerializer.new(websites, each_serializer: WebsiteSerializer)

    expect(serializer.to_json).to eql('[{"id":"506144650ed4c08d84000001","name":"some name","url":"some url"},{"id":"506144650ed4c08d84000001","name":"some name","url":"some url"}]')
  end

  # describe "custom attributes" do
  #   let(:website) {FactoryGirl.create(:website)}

  #   it "sets images to sort count" do
  #     FactoryGirl.create(:image, :website => website, :status => Image::TO_KEEP_STATUS)
  #     FactoryGirl.create(:image, :website => website, :status => Image::TO_SORT_STATUS)
  #     serializer = WebsiteSerializer.new website

  #     JSON.parse(serializer.to_json)["website"]["images_to_sort_count"].should == 1
  #   end

  #   context "has latest post" do
  #     it "sets latest post id" do
  #       post = FactoryGirl.create(:post, :website => website, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
  #       website.stubs(:latest_post).returns(post)
  #       serializer = WebsiteSerializer.new website

  #       JSON.parse(serializer.to_json)["website"]["latest_post_id"].should == "506144650ed4c08d84000001"
  #     end
  #   end

  #   context "doesn't have any latest post" do
  #     it "sets latest post id" do
  #       serializer = WebsiteSerializer.new website

  #       JSON.parse(serializer.to_json)["website"]["latest_post_id"].should == nil
  #     end
  #   end
  # end
end