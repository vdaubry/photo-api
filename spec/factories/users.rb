FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "string#{n}@string.fr"}
    password "string"
    authentication_token "string"    
  end
end