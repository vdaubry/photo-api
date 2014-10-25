require "rails_helper"

describe "S3" do
  describe "url" do
    let (:url) { Facades::S3.new(IMAGE_BUCKET).url("thumbnail/300x300/141/141009/141009897/1410098972_1940512.jpg").to_s }

    it "returns an url on S3" do
      url.include?("https://photovisualizer-dev.s3.amazonaws.com/thumbnail/300x300/141/141009/141009897/1410098972_1940512.jpg").should == true
    end

    it "signs the url" do
      url.include?("Signature=").should == true
      url.include?("Expires=").should == true
    end
  end
end