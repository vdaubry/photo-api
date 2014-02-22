class Scrapping
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :website
  has_many :posts

  field :date, type: Time
  field :duration, type: Integer
  field :image_count, type: Integer
  field :success, type: Boolean

  validates_uniqueness_of :website_id, :scope => :date

  index({ website_id: 1, date: 1 }, { unique: true })
  #index({'posts.name'=> 1}, {unique: true})
end
