require 'spec_helper'

describe Scrapping do

	describe "save" do
		context "valid" do 
			it { FactoryGirl.build(:scrapping).save.should == true }

			it { 
				date = 1.day.ago
				FactoryGirl.create(:scrapping, :date => date, :website => FactoryGirl.create(:website), :success => true)
				FactoryGirl.build(:scrapping, :date => date, :website => FactoryGirl.create(:website), :success => false).save.should == true
			}

			it {
				scrapping = FactoryGirl.create(:scrapping)
				posts = FactoryGirl.create_list(:post, 2, :scrapping => scrapping)
				scrapping.posts.count.should == 2
				Scrapping.first.posts.count.should == 2
			}
		end

		context "duplicates url and date" do 
			it { 
				date = 1.day.ago
				website = FactoryGirl.create(:website)
				FactoryGirl.create(:scrapping, :date => date, :website => website, :success => true)
				FactoryGirl.build(:scrapping, :date => date, :website => website, :success => false).save.should == false 
			}
		end

		context "thread" do
			context "duplicates for a date" do
				it {
					scrapping = FactoryGirl.create(:scrapping)
					post = FactoryGirl.create(:post, :scrapping => scrapping, :name => "foo")
					post2 = FactoryGirl.build(:post, :scrapping => scrapping, :name => "foo").save.should == false
				}
			end
		end
	end
end
