require 'rails_helper'

describe Image do

	describe "save" do
		context "valid" do
			it { FactoryGirl.build(:image).save.should == true }
		end
		
		context "null values" do
			it { FactoryGirl.build(:image, :key => nil).save.should == false }
			it { FactoryGirl.build(:image, :image_hash => nil).save.should == false }
			it { FactoryGirl.build(:image, :file_size => nil).save.should == false }
			it { FactoryGirl.build(:image, :width => nil).save.should == false }
			it { FactoryGirl.build(:image, :height => nil).save.should == false }
			it { FactoryGirl.build(:image, :source_url => nil).save.should == false }
			it { FactoryGirl.build(:image, :post => nil).save.should == true }
			it { FactoryGirl.build(:image, :website => nil).save.should == false }
			it { FactoryGirl.build(:image, :scrapped_at => nil).save.should == false }
		end

		context "too small" do
			it "saves all images" do
				FactoryGirl.build(:image, :width => 300, :height => 300).save.should == true
				FactoryGirl.build(:image, :width => 299).save.should == true
				FactoryGirl.build(:image, :height => 299).save.should == true
			end
		end

		context "similar image with different source_url" do
			it "doesn't save image" do
				FactoryGirl.create(:image, :image_hash => "abcd")
				FactoryGirl.build(:image, :image_hash => "abcd").save.should == false
			end
		end

		context "image with same source_url already exists" do
			it "doesn't save image" do
				FactoryGirl.create(:image, :source_url => "http://www.foo.bar/img.png")
				FactoryGirl.build(:image, :source_url => "http://www.foo.bar/img.png").save.should == false
			end
		end

		context "forbidden hash" do
			it "doesn't save image" do
				FactoryGirl.build(:image, :image_hash => "70bdfc7b6bc66aa8e71cf1915a1cf3fa").save.should == false
			end
		end

		context "duplicate key" do
			it "doesn't save image" do
				FactoryGirl.build(:image, :key => "azerty").save.should == true
				FactoryGirl.build(:image, :key => "azerty").save.should == false
			end
		end		
	end
end
