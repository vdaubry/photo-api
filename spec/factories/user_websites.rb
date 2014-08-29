FactoryGirl.define do
  factory :user_website do
    sequence(:name) {|n| "string#{n}"} 
    sequence(:url) {|n| "string#{n}"} 
    user { FactoryGirl.create(:user) }
  end
end