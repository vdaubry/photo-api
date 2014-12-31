require "rails_helper"

describe Image::RemoteFile do
  # describe "create_zip" do
  #   context "has images to keep" do
  #     it "sends SQS with images to keep keys" do
  #       FactoryGirl.create(:image, :status => Image::TO_SORT_STATUS)
  #       FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS, :key => "1397897025_1135558.jpg")
  #       FactoryGirl.create(:image, :status => Image::TO_KEEP_STATUS, :key => "1397897084_1135571.jpg")
  #       FactoryGirl.create(:image, :status => Image::TO_DELETE_STATUS)

  #       Facades::SQS.any_instance.expects(:send).with(["image/139/139789/139789702/1397897025_1135558.jpg", "image/139/139789/139789708/1397897084_1135571.jpg"].to_json)
  #       Image.create_zip
  #     end
  #   end

  #   context "no images to keep" do
  #     it "doesn't send SQS message" do
  #       Facades::SQS.any_instance.expects(:send).never
  #       Image.create_zip
  #     end
  #   end
  # end

  # describe "listen_for_done_zip" do
  #   before(:each) do
  #     Facades::SQS.any_instance.stubs(:poll).yields({:zipkey => "foobar.zip"}.to_json)
  #   end

  #   it "saves zipfile key" do
  #     Image.listen_for_done_zip
  #     Zipfile.last.key.should == "foobar.zip"
  #   end

  #   it "sets to keep files to kept" do
  #     img = FactoryGirl.create(:image, :status => "TO_KEEP_STATUS")
  #     Image.listen_for_done_zip
  #     img.reload.status.should == "KEPT_STATUS"
  #   end

  #   it "sets to delete files to deleted" do
  #     img = FactoryGirl.create(:image, :status => "TO_DELETE_STATUS")
  #     Image.listen_for_done_zip
  #     img.reload.status.should == "DELETED_STATUS"
  #   end
    
  # end
end