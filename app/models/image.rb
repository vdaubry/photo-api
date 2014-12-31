require 'open-uri'

class Image
  extend Image::RemoteFile

  THUMBS_FORMAT="300x300"

  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :website, index: true
  belongs_to :post, index: true
  has_one :user_image
  index({ image_hash: 1}, { unique: true, drop_dups: true })
  index({ source_url: 1}, { unique: true, drop_dups: true })
  index({ key: 1}, { unique: true, drop_dups: true })

  field :key, type: String
  field :image_hash, type: String
  field :file_size, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :source_url, type: String
  field :hosting_url, type: String
  field :scrapped_at, type: DateTime

  validates :key, :image_hash, :file_size, :width, :height, :source_url, :website, :scrapped_at, presence: true, allow_blank: false, allow_nil: false
  validates_uniqueness_of :image_hash, :source_url, :key
  validate :forbidden_image_hash

  before_create :check_image_size

  paginates_per 50

  def forbidden_image_hash
    #image hashes for error images : rate limited, image not found, etc
    forbidden_hashes = ["70bdfc7b6bc66aa8e71cf1915a1cf3fa"]
    if forbidden_hashes.include?(image_hash)
      errors.add(:image_hash, "Image cannot be saved : hash is forbidden. \n #{attributes}")
      Rails.logger.error("Received a forbidden hash : #{attributes}")
    end

  end

  def thumbnail_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.thumbnail_path(key, THUMBS_FORMAT)).to_s
  end

  def fullsize_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.image_path(key)).to_s
  end

  private

  def check_image_size
    width_too_small = width && width < 300
    height_too_small = height && height < 300
    errors.add(:image_hash, "Image cannot be saved, size too small : width = #{width} , height = #{height}")
    Rails.logger.error("Received a too smal image : width = #{width} , height = #{height}")
  end
end
