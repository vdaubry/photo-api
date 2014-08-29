require "rails_helper"

describe WebsitePost do
  describe "create" do
    context "valid website_post" do
      it { FactoryGirl.build(:website_post).save.should == true }
    end
  end
end