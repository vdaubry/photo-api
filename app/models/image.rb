require 'open-uri'

class Image
  TO_KEEP_STATUS="TO_KEEP_STATUS"
  TO_SORT_STATUS="TO_SORT_STATUS"
  TO_DELETE_STATUS="TO_DELETE_STATUS"
  DELETED_STATUS="DELETED_STATUS"
  KEPT_STATUS="KEPT_STATUS"

  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :website
  belongs_to :post
  delegate :update_post_status, :to => :post

  field :key, type: String
  field :image_hash, type: String
  field :status, type: String
  field :file_size, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :source_url, type: String
  field :hosting_url, type: String

  validates :key, :image_hash, :status, :file_size, :width, :height, :source_url, :website, presence: true, allow_blank: false, allow_nil: false
  validates_inclusion_of :status, in: [ TO_KEEP_STATUS, TO_SORT_STATUS, TO_DELETE_STATUS, DELETED_STATUS, KEPT_STATUS ]

  before_create :check_image_size

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :to_keep, -> {where(:status => TO_KEEP_STATUS)}
  scope :to_delete, -> {where(:status => TO_DELETE_STATUS)}

  paginates_per 50

  private

  def check_image_size
    width_too_small = width && width < 300
    height_too_small = height && height < 300
    self.status=TO_DELETE_STATUS if width_too_small or height_too_small
  end
end
