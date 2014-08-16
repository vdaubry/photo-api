require 'rails_helper'

describe ScrappingsController do
  render_views

  let(:website) { FactoryGirl.create(:website) }
  let(:scrapping) { FactoryGirl.create(:scrapping, :id => "5314e4264d6163063f020000", :website => website, :image_count => 0) }

  def valid_attributes
    { :date => "02/01/2010", :duration => 3600, :image_count => 123, :success => false }
  end

  describe "POST create" do
    it "creates a new scrapping" do
      expect{
        post 'create', :format => :json, :scrapping => valid_attributes, :website_id => website.id
       }.to change{Scrapping.count}.by(1)
    end
  end

  describe "PUT update" do
    it "updates scrapping" do
      put 'update', :format => :json, :scrapping => valid_attributes, :website_id => website.id, :id => scrapping.id
      
      scrapping = JSON.parse(response.body)["scrapping"]
      scrapping["date"].should == "2010-01-02T00:00:00.000Z"
    end

    context "success" do
      it "sets number of downloaded images" do
        post = FactoryGirl.create(:post, :scrapping => scrapping)
        FactoryGirl.create_list(:image, 2, :post => post, :status => Image::TO_SORT_STATUS)

        put 'update', :format => :json, :scrapping => { :date => "02/01/2010", :duration => 3600, :success => true }, :website_id => website.id, :id => scrapping.id
        
        scrapping.reload.image_count.should == 2
      end
    end
    
    context "failure" do
      it "doesn't set number of downloaded images" do
        post = FactoryGirl.create(:post, :scrapping => scrapping)
        FactoryGirl.create_list(:image, 2, :post => post, :status => Image::TO_SORT_STATUS)

        put 'update', :format => :json, :scrapping => { :date => "02/01/2010", :duration => 3600, :success => false }, :website_id => website.id, :id => scrapping.id
        
        scrapping.reload.image_count.should == 0
      end
    end
  end
end