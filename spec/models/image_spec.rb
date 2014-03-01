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
	end

	describe "build info" do
		let(:website) { FactoryGirl.create(:website) }
		let(:post) { FactoryGirl.create(:post) }

		it "create a new image with parameters" do
			fake_date = DateTime.parse("01/01/2014")
			DateTime.stubs(:now).returns fake_date
			url = "http://foo.bar"
			
			img = Image.new.build_info(url, website, post)

			img.source_url.should == url
			img.website.should == website
			img.key.should == fake_date.to_i.to_s + "_" + File.basename(URI.parse(url).path)
			img.status.should == Image::TO_SORT_STATUS
			img.post.should == post
		end

		it "format special characters" do
			fake_date = DateTime.parse("01/01/2014")
			DateTime.stubs(:now).returns fake_date
			url = "http://foo.bar/abc-jhvg-emil123.jpg"

			img = Image.new.build_info(url, website, post)

			img.key.should == fake_date.to_i.to_s + "_" + "abc_jhvg_emil123.jpg"
		end
	end

	describe "download" do
		let(:image) { FactoryGirl.build(:image, :key => "calinours.jpg") }

		it "saves file" do
			Image.stubs(:image_path).returns("spec/ressources")
			Image.stubs(:thumbnail_path).returns("spec/ressources/thumb")
			image.stub_chain(:open, :read) { File.open("ressources/calinours.jpg").read }

			image.download

			image.persisted?.should == true
		end

		it "assigns image to post" do
			post1 = FactoryGirl.create(:post)
			website1 = FactoryGirl.create(:website)
			url = "http://foo.bar"
			image = Image.new.build_info(url, website1, post1)
			image.key="calinours.jpg"
			Image.stubs(:image_path).returns("spec/ressources")
			Image.stubs(:thumbnail_path).returns("spec/ressources/thumb")
			image.stub_chain(:open, :read) { File.open("spec/ressources/calinours.jpg").read }
			image.stubs(:image_save_path).returns("spec/ressources/calinours.jpg")

			image.download

			saved_image = Image.find(image.id)
			saved_image.post.should == post1
			saved_image.website.should == website1
			saved_image.source_url.should == url

			post1.images.should == [image]
			website1.images.should == [image]
		end

		context "raises exception" do
			before(:each) do
				image.stubs(:image_save_path).returns("spec/ressources/calinours.jpg")
				@image = FactoryGirl.create(:image, :key => "calinours.jpg")
			end

			it "catches timeout error and keep image" do
				@image.stubs(:open).raises(Timeout::Error)
				@image.download
				@image.persisted?.should == true
			end

			it "catches 404 error and delete image" do
				@image.stubs(:open).raises(OpenURI::HTTPError.new('',mock('io')))
				@image.download
				@image.persisted?.should == false
			end

			it "catches file not found and keep image" do
				@image.stubs(:open).raises(Errno::ENOENT)
				@image.download
				@image.persisted?.should == true
			end
		end

		it "uploads file to FTP" do
			image.stub_chain(:open, :read) { File.open("spec/ressources/calinours.jpg").read }
			image.stubs(:generate_thumb).returns(true)
			image.stubs(:set_image_info).returns(true)
			Facades::Ftp.any_instance.expects(:upload_file).with(image)

			image.download
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

	describe "set_image_info" do
		let(:image) { FactoryGirl.build(:image, :key => "calinours.jpg") }

		before(:each) do
			image.stubs(:image_save_path).returns("spec/ressources/calinours.jpg")
		end

		it  {
			image.set_image_info

			image.image_hash.should == "bf5ce4c682bd955f6ebd8b9ea03fe58a"
			image.file_size.should == 70994
			image.width.should == 600
			image.height.should == 390
		}
		
		context "valid image" do
			it "saves image" do
				image.stubs(:image_invalid?).returns(false)

				image.set_image_info

				image.persisted?.should == true
			end
		end

		context "invalid image" do
			it "saves image" do
				image.stubs(:image_invalid?).returns(true)

				image.set_image_info

				image.persisted?.should == false
			end
		end
	end

	describe "image_invalid?" do
		it { FactoryGirl.build(:image).image_invalid?.should == false }

		it { FactoryGirl.build(:image, :width => 200).image_invalid?.should == true }

		it { FactoryGirl.build(:image, :height => 200).image_invalid?.should == true }

		it { 
			FactoryGirl.create(:image, :image_hash => "foo")
			FactoryGirl.build(:image, :image_hash => "foo").image_invalid?.should == true
		}
	end
end
