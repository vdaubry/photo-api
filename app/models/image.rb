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

  field :key, type: String
  field :image_hash, type: String
  field :status, type: String
  field :file_size, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :source_url, type: String
  field :hosting_url, type: String

  validates :key, :image_hash, :status, :file_size, :width, :height, :source_url, :website, presence: true, allow_blank: false, allow_nil: false
  validate :image_size, :on => :create
  validates_inclusion_of :status, in: [ TO_KEEP_STATUS, TO_SORT_STATUS, TO_DELETE_STATUS, DELETED_STATUS, KEPT_STATUS ]

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :to_keep, -> {where(:status => TO_KEEP_STATUS)}
  scope :to_delete, -> {where(:status => TO_DELETE_STATUS)}

  paginates_per 50

  private

  def image_size
    self.errors.add :width, 'too small' if width && width < 300
    self.errors.add :height, 'too small' if height && height < 300
  end
end
