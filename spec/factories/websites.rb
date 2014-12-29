FactoryGirl.define do
  factory :website do
    sequence(:name) {|n| "string#{n}"}
    sequence(:url) {|n| "string#{n}"}
  end
end