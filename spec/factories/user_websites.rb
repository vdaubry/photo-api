FactoryGirl.define do
  factory :user_website do
    name "string"
    url "string" 
    user { FactoryGirl.create(:user) }
  end
end