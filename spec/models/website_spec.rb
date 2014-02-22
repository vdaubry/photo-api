require 'spec_helper'

describe Website do

	before :each do
	end

	describe "save" do
		context "valid" do 
			it { FactoryGirl.build(:website).save.should == true }
			it { 
				website = FactoryGirl.create(:website)
				FactoryGirl.create_list(:image, 2, :website => website)
				FactoryGirl.create(:scrapping, :website => website, :date => Date.today)
				FactoryGirl.create(:scrapping, :website => website, :date => 1.week.ago)

				website.images.count.should==2
				website.scrappings.count.should==2
			}
			it {
				posts = FactoryGirl.create_list(:post, 2)
				website = FactoryGirl.create(:website)
				website.posts.push(posts)
				website.posts.count == 2
			}

		end
	end
end
