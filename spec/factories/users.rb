FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "string#{n}@string.fr"}
    password "string"
    sequence(:authentication_token) {|n| "string#{n}" }
  end
end