FactoryGirl.define do
  factory :post do
    sequence(:name) { |n| "name_#{n}" }
    website { FactoryGirl.create(:website) }
  end
end