require 'rails_helper'

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
			it "saves all images" do
				FactoryGirl.build(:image, :width => 300, :height => 300).save.should == true
				FactoryGirl.build(:image, :width => 299).save.should == true
				FactoryGirl.build(:image, :height => 299).save.should == true
			end

			it "sets small images to TO_DELETE status" do
				FactoryGirl.create(:image, :width => 300, :height => 300, :status => Image::TO_SORT_STATUS).status.should == Image::TO_SORT_STATUS
				FactoryGirl.create(:image, :width => 299, :status => Image::TO_SORT_STATUS).status.should == Image::TO_DELETE_STATUS
				FactoryGirl.create(:image, :height => 299, :status => Image::TO_SORT_STATUS).status.should == Image::TO_DELETE_STATUS
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

	describe "transfert" do
		before (:each) do
			@image1 = FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS, :key => "image1")
			@image2 = FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS, :key => "image2")
			@image3 = FactoryGirl.create(:image, :status => Image::TO_DELETE_STATUS, :key => "image3")
		end

		it "deletes all images to_delete_status" do
			Facades::Ftp.any_instance.expects(:delete_files).with(["image3"])
			Image.transfert
		end

		it "copies all images to_keep" do
			Facades::Ftp.any_instance.expects(:move_files_to_keep).with(["image2"])
			Image.transfert
		end

		it "sets all images to_keep_status to kept_status" do
			Image.transfert
			@image2.reload.status.should == Image::KEPT_STATUS
		end

		it "sets all images to_delete_status to deleted_status" do
			Image.transfert
			@image3.reload.status.should == Image::DELETED_STATUS
		end
	end
end
