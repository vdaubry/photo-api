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
  validates_inclusion_of :status, in: [ TO_KEEP_STATUS, TO_SORT_STATUS, TO_DELETE_STATUS, DELETED_STATUS, KEPT_STATUS ]

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :to_keep, -> {where(:status => TO_KEEP_STATUS)}
  scope :to_delete, -> {where(:status => TO_DELETE_STATUS)}

  def build_info(source_url, hosting_url=nil, website, post)
    self.source_url = source_url
    self.hosting_url = hosting_url
    self.website = website
    self.key = (DateTime.now.to_i.to_s + "_" + File.basename(URI.parse(source_url).path)).gsub('-', '_').gsub(/[^0-9A-Za-z_\.]/, '')
    self.status = Image::TO_SORT_STATUS
    self.post = post
    self
  end

  # def key
  #   Rails.env.development? ? "calinours.jpg" : self[:key]
  # end

  def self.image_path
    "app/assets/images/to_sort"
  end

  def self.thumbnail_path
    "app/assets/images/to_sort/thumbnails/300"
  end

  def self.asset_thumbnail_path
    "to_sort/thumbnails/300"
  end  

  def image_save_path
    "#{Image.image_path}/#{self[:key]}"
  end

  def generate_thumb
    image = MiniMagick::Image.open(image_save_path) 
    image.resize "300x300"
    image.write  "#{Image.thumbnail_path}/#{self[:key]}"
  end

  def set_image_info
    image_file = File.read(image_save_path)
    self.image_hash = Digest::MD5.hexdigest(image_file)
    self.width = FastImage.size(image_save_path)[0]
    self.height = FastImage.size(image_save_path)[1]
    self.file_size = image_file.size

    if image_invalid?
      destroy
    else
      save!
    end
  end

  def image_invalid?
    too_small = (self.width < 300 || self.height < 300)
    Rails.logger.warn "Too small" if too_small
    already_downloaded = Image.where(:image_hash => image_hash).count > 0
    Rails.logger.warn "already_downloaded" if already_downloaded
    (too_small || already_downloaded)
  end

  def download(page_image=nil)
    begin
      if page_image
        page_image.fetch.save image_save_path #To protect from hotlinking we reuse the same session
      else
        open(image_save_path, 'wb') do |file|
          file << open(source_url, :allow_redirections => :all).read
        end
      end
      
      generate_thumb
      set_image_info
    rescue StandardError => e
      Rails.logger.error e.to_s
    end
  end

end
