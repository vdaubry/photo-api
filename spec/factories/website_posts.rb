FactoryGirl.define do
  factory :website_post do
    name 'string'
    user_website { FactoryGirl.create(:user_website) }
  end
end