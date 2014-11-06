require 'open-uri'

class Image
  extend Image::RemoteFile

  #TODO : A supprimer
  TO_KEEP_STATUS="TO_KEEP_STATUS"
  TO_SORT_STATUS="TO_SORT_STATUS"
  TO_DELETE_STATUS="TO_DELETE_STATUS"
  DELETED_STATUS="DELETED_STATUS"
  KEPT_STATUS="KEPT_STATUS"

  #TODO : A supprimer
  THUMBS_FORMAT="300x300"

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
  field :scrapped_at, type: DateTime

  validates :key, :image_hash, :status, :file_size, :width, :height, :source_url, :website, :scrapped_at, presence: true, allow_blank: false, allow_nil: false
  validates_inclusion_of :status, in: [ TO_KEEP_STATUS, TO_SORT_STATUS, TO_DELETE_STATUS, DELETED_STATUS, KEPT_STATUS ]
  validates_uniqueness_of :image_hash, :source_url, :key
  validate :forbidden_image_hash

  before_create :check_image_size

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :to_keep, -> {where(:status => TO_KEEP_STATUS)}
  scope :to_delete, -> {where(:status => TO_DELETE_STATUS)}

  paginates_per 50

  def forbidden_image_hash
    #image hashes for error images : rate limited, image not found, etc
    forbidden_hashes = ["70bdfc7b6bc66aa8e71cf1915a1cf3fa"]
    if forbidden_hashes.include?(image_hash)
      errors.add(:image_hash, "Image cannot be saved : hash is forbidden. \n #{attributes}")
      Rails.logger.error("Received a forbidden hash : #{attributes}")
    end

  end

  #TODO : A supprimer
  def thumbnail_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.thumbnail_path(key, THUMBS_FORMAT)).to_s
  end

  #TODO : A supprimer
  def fullsize_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.image_path(key)).to_s
  end

  private

  def check_image_size
    width_too_small = width && width < 300
    height_too_small = height && height < 300
    self.status=TO_DELETE_STATUS if width_too_small or height_too_small
  end
end
