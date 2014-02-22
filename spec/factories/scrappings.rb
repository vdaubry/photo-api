FactoryGirl.define do
  factory :scrapping do
    date DateTime.now
    duration 1234
    image_count 1234
    success true
    website { FactoryGirl.create(:website) }
  end
end