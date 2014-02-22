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
		it "saves file" do
			image = FactoryGirl.build(:image, :key => "calinours.jpg")
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
			let(:image) { FactoryGirl.build(:image, :key => "calinours.jpg") }
			
			it "catches timeout error" do
				image.stubs(:open).raises(Timeout::Error)
				image.download
			end

			it "catches 404 error" do
				image.stubs(:open).raises(OpenURI::HTTPError)
				image.download
			end

			it "catches file not found" do
				image.stubs(:open).raises(Errno::ENOENT)
				image.download
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

	describe "set_image_info" do
		let(:image) { FactoryGirl.build(:image, :key => "calinours.jpg") }

		before(:each) do
			image.stubs(:image_save_path).returns("spec/ressources/calinours.jpg")
		end

		it  {
			image.set_image_info

			image.image_hash.should == "a1e4b773a5cd2941a4a442b7309c8ced"
			image.file_size.should == 197890
			image.width.should == 1200
			image.height.should == 780
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
