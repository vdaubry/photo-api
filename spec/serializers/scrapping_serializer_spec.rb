require 'spec_helper'

describe ScrappingSerializer do

  it "serializes a scrapping" do
    scrapping = FactoryGirl.create(:scrapping, :id => "5314e4264d6163063f020000", :date => "02/01/2010", :duration => 3600, :image_count => 123, :success => false)
    serializer = ScrappingSerializer.new scrapping

    expect(serializer.to_json).to eql('{"scrapping":{"id":"5314e4264d6163063f020000","date":"2010-01-02T00:00:00.000Z","duration":3600,"image_count":123,"success":false}}')
  end

end