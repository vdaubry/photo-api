FactoryGirl.define do
  factory :user_post do
    website { FactoryGirl.create(:website) }
    post { FactoryGirl.create(:post, :website => website) }
    user { FactoryGirl.create(:user) }
    pages_seen []
    current_page 1
  end
end