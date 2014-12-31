FactoryGirl.define do
  factory :image do
    sequence(:key ) { |n| "key_#{n}" }
    sequence(:image_hash ) { |n| "hash_#{n}" }
    file_size 1234
    width 1234
    height 1234
    sequence(:source_url ) { |n| "http://www.foo.bar/#{n}.jpg" }
    website { FactoryGirl.create(:website) }
    scrapped_at DateTime.parse("20/10/2010")
  end
end