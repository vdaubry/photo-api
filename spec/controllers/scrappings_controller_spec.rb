require 'spec_helper'

describe ScrappingsController do
  render_views

  describe "POST create" do
    let(:website) { FactoryGirl.create(:website) }
    
    def valid_attributes
      { :date => "02/01/2010", :duration => 3600, :image_count => 123, :success => false }
    end

    it "creates a new scrapping" do
      expect{
        post 'create', :format => :json, :scrapping => valid_attributes, :website_id => website.id
       }.to change{Scrapping.count}.by(1)
    end
  end
end