require "rails_helper"

describe PostImage do
  describe "create" do
    let(:website_post) { FactoryGirl.create(:website_post) }
    let(:website_post2) { FactoryGirl.create(:website_post) }

    context "valid PostImage" do
      it { FactoryGirl.build(:post_image).save.should == true }
    end

    context "duplicate key" do
      it { 
        FactoryGirl.build(:post_image, :key => "foo", :website_post => website_post).save.should == true 
        FactoryGirl.build(:post_image, :key => "foo", :website_post => website_post).save.should == false
      }
    end

    context "same key for different website_post" do
      it {
        FactoryGirl.build(:post_image, :key => "foo", :website_post => website_post).save.should == true 
        FactoryGirl.build(:post_image, :key => "foo", :website_post => website_post2).save.should == true
      }
    end
  end
end