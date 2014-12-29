class UserImage
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :image
  belongs_to :post, index: true
  belongs_to :website, index: true
  belongs_to :user, index: true
end