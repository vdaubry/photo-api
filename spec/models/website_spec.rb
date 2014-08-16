require 'rails_helper'

describe Website do

	let(:website) { FactoryGirl.create(:website) }

	describe "save" do
		context "valid" do 
			it { FactoryGirl.build(:website).save.should == true }
			
			it "has images and websites" do
				FactoryGirl.create_list(:image, 2, :website => website)
				FactoryGirl.create(:scrapping, :website => website, :date => Date.today)
				FactoryGirl.create(:scrapping, :website => website, :date => 1.week.ago)

				website.images.count.should==2
				website.scrappings.count.should==2
			end
			
			it "can adds post to post list" do
				posts = FactoryGirl.create_list(:post, 2)
				website.posts.push(posts)
				website.posts.count == 2
			end
		end
	end

	describe "latest_post_id" do
		it "returns website post with status to sort ordered by updated_at ASC" do
			post1 = FactoryGirl.create(:post, :website => website, :status => Post::SORTED_STATUS)
			post2 = FactoryGirl.create(:post, :website => website, :status => Post::TO_SORT_STATUS, :updated_at => Date.parse("02/01/2010"), :created_at => Date.parse("02/01/2010"), :banished => false)
			post3 = FactoryGirl.create(:post, :website => website, :status => Post::TO_SORT_STATUS, :updated_at => Date.parse("03/01/2010"), :created_at => Date.parse("03/01/2010"), :banished => false)
			post4 = FactoryGirl.create(:post, :website => nil,		 :status => Post::TO_SORT_STATUS, :updated_at => Date.parse("01/01/2010"), :created_at => Date.parse("01/01/2010"), :banished => false)
			post5 = FactoryGirl.create(:post, :website => website, :status => Post::TO_SORT_STATUS, :updated_at => Date.parse("01/01/2010"), :created_at => Date.parse("01/01/2010"), :banished => true)
			
			website.latest_post_id.should == post2.id.to_s
		end

		it "returns website post when none is banished" do
			post1 = FactoryGirl.create(:post, :website => website, :status => Post::TO_SORT_STATUS, :banished => nil)
			website.latest_post_id.should == post1.id.to_s
		end
	end
end
