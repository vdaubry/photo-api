FactoryGirl.define do
  factory :image do
    sequence(:key ) { |n| "key_#{n}" }
    sequence(:image_hash ) { |n| "hash_#{n}" }
    status Image::TO_KEEP_STATUS
    file_size 1234
    width 1234
    height 1234
    source_url "string"
    website { FactoryGirl.create(:website) }
  end
end