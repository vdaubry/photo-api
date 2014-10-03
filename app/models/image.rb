require 'open-uri'

class Image
  TO_KEEP_STATUS="TO_KEEP_STATUS"
  TO_SORT_STATUS="TO_SORT_STATUS"
  TO_DELETE_STATUS="TO_DELETE_STATUS"
  DELETED_STATUS="DELETED_STATUS"
  KEPT_STATUS="KEPT_STATUS"

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

  # def self.transfert
  #   raise "Cannot sort images when calinours safety is on !!" if Image.first.key == "calinours.jpg"

  #   ftp = Facades::Ftp.new

  #   Rails.logger.info "Deleting #{Image.where(:status => Image::TO_DELETE_STATUS).count} images"
  #   keys = Image.where(:status => Image::TO_DELETE_STATUS).map(&:key)
  #   ftp.delete_files(keys)
    

  #   Rails.logger.info "Saving #{Image.where(:status => Image::TO_KEEP_STATUS).count} images"
  #   keys = Image.where(:status => Image::TO_KEEP_STATUS).map(&:key)
  #   ftp.move_files_to_keep(keys)

  #   Image.where(:status => Image::TO_KEEP_STATUS).update_all(:status => Image::KEPT_STATUS)
  #   Image.where(:status => Image::TO_DELETE_STATUS).update_all(:status => Image::DELETED_STATUS)
  # end

  def thumbnail_url
    Facades::S3.new.thumbnail_url(key, THUMBS_FORMAT).to_s
  end

  private

  def check_image_size
    width_too_small = width && width < 300
    height_too_small = height && height < 300
    self.status=TO_DELETE_STATUS if width_too_small or height_too_small
  end
end
