require 'spec_helper'

describe Image do

	describe "save" do
		context "valid" do
			it { FactoryGirl.build(:image).save.should == true }
		end
		
		context "null values" do
			it { FactoryGirl.build(:image, :key => nil).save.should == false }
			it { FactoryGirl.build(:image, :image_hash => nil).save.should == false }
			it { FactoryGirl.build(:image, :status => nil).save.should == false }
			it { FactoryGirl.build(:image, :file_size => nil).save.should == false }
			it { FactoryGirl.build(:image, :width => nil).save.should == false }
			it { FactoryGirl.build(:image, :height => nil).save.should == false }
			it { FactoryGirl.build(:image, :source_url => nil).save.should == false }
			it { FactoryGirl.build(:image, :post => nil).save.should == true }
			it { FactoryGirl.build(:image, :website => nil).save.should == false }
		end

		context "invalid status" do
			it { FactoryGirl.build(:image, :status => "foo").save.should == false }
		end

		context "too small" do
			it { FactoryGirl.build(:image, :width => 300, :height => 300).save.should == true }
			it { FactoryGirl.build(:image, :width => 299).save.should == false }
			it { FactoryGirl.build(:image, :height => 299).save.should == false }
		end
	end

	describe "scopes" do
		before(:each) do
			@img_to_sort = FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS)
			@img_to_keep = FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS)
			@img_to_delete = FactoryGirl.create(:image, :status => Image::TO_DELETE_STATUS)
		end

		it {Image.to_sort.should == [@img_to_sort]}
		it {Image.to_keep.should == [@img_to_keep]}
		it {Image.to_delete.should == [@img_to_delete]}
	end
end
