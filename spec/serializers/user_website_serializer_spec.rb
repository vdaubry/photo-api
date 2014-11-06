require 'rails_helper'

describe WebsiteSerializer do

  it "serializes a user_website" do
    website = FactoryGirl.create(:user_website, :url => "some url", :name => "some name", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = UserWebsiteSerializer.new website

    expect(serializer.to_json).to eql('{"user_website":{"id":"506144650ed4c08d84000001","name":"some name","url":"some url","latest_post_id":null}}')
  end

  it "serializes an array of user_websites" do
    websites = FactoryGirl.build_list(:user_website, 2, :url => "some url", :name => "some name", :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
    serializer = ActiveModel::ArraySerializer.new(websites, each_serializer: UserWebsiteSerializer)

    expect(serializer.to_json).to eql('[{"id":"506144650ed4c08d84000001","name":"some name","url":"some url","latest_post_id":null},{"id":"506144650ed4c08d84000001","name":"some name","url":"some url","latest_post_id":null}]')
  end

  describe "custom attributes" do
    let(:website) {FactoryGirl.create(:user_website)}

    context "has latest post" do
      it "sets latest post id" do
        post = FactoryGirl.create(:website_post, :user_website => website, :id => BSON::ObjectId.from_string('506144650ed4c08d84000001'))
        website.stubs(:latest_post).returns(post)
        serializer = UserWebsiteSerializer.new website

        JSON.parse(serializer.to_json)["user_website"]["latest_post_id"].should == "506144650ed4c08d84000001"
      end
    end

    context "doesn't have any latest post" do
      it "sets latest post id" do
        serializer = UserWebsiteSerializer.new website

        JSON.parse(serializer.to_json)["user_website"]["latest_post_id"].should == nil
      end
    end
  end
end