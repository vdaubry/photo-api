FactoryGirl.define do
  factory :post do
    sequence(:name) { |n| "name_#{n}" }
    status Post::TO_SORT_STATUS
    pages_url []
    scrapping { FactoryGirl.create(:scrapping) }
    website { FactoryGirl.create(:website) }
    banished false
  end
end