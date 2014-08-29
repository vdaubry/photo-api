FactoryGirl.define do
  factory :post_image do
    sequence(:key) {|n| "string#{n}" }
    website_post { FactoryGirl.create(:website_post) }
  end
end