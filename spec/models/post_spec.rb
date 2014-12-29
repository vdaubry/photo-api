require 'rails_helper'

describe Post do

	describe "save" do
		context "valid" do
			it { FactoryGirl.build(:post).save.should == true }

			it { 
				images = FactoryGirl.create_list(:image, 2)
				post = FactoryGirl.create(:post)
				post.images = images
				post.images.count.should == 2
			}
		end
	end
  
end
