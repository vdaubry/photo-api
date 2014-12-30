class UserPost
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :post, index: true
  belongs_to :website, index: true
  belongs_to :user
  
  field :current_page, type: Integer
end