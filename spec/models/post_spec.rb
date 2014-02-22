require 'spec_helper'

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

		context "invalid status" do
			it { FactoryGirl.build(:post, :status => "foo").save.should == false }
		end
	end

	describe "scopes" do
		before(:each) do
			@post_to_sort = FactoryGirl.create(:post, :status => Post::TO_SORT_STATUS)
			@sorted_post = FactoryGirl.create(:post, :status => Post::SORTED_STATUS)
		end

		it {Post.to_sort.should == [@post_to_sort]}
		it {Post.sorted.should == [@sorted_post]}
	end

	describe "pages_url" do
		let(:post) { FactoryGirl.create(:post) }

		it "contains multiple urls" do
			post.push(pages_url: "http://foo.bar")
			post.push(pages_url: "http://foo.bar")
			post.save!
			Post.find(post.id).pages_url.count.should == 2
		end

		it "finds existing url" do
			post.pages_url.push "http://foo.bar"
			post.pages_url.push "http://otherfoo.bar2"
			post.save!
			Post.where(:pages_url.in => ["http://foo.bar"]).entries.should == [post]
			Post.where(:pages_url.in => ["http://otherfoo.bar2"]).entries.should == [post]
		end

		describe "add_to_set" do
			it "adds unique values" do
				post.add_to_set(pages_url: "http://foo.bar")
				post.add_to_set(pages_url: "http://foo.bar")
				post.save!
				Post.find(post.id).pages_url.count.should == 1
			end

			it "finds existing url" do
				post.add_to_set(pages_url: "http://foo.bar")
				post.add_to_set(pages_url: "http://foo.bar")
				post.save!
				Post.where(:pages_url.in => ["http://foo.bar"]).entries.should == [post]
				Post.where(:pages_url.in => ["http://otherfoo.bar2"]).entries.should == []
			end
		end
	end

	describe "with_page_url" do
		let(:post) { FactoryGirl.create(:post) }
		
		it "returns posts wich contains the url" do
			post.pages_url.push "http://foo.bar"
			post.save!
			Post.with_page_url("http://foo.bar").entries.should == [post]
			Post.with_page_url("foo.bar").entries.should == []
		end
	end
end
