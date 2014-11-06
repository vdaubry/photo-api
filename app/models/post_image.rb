class PostImage
  include Mongoid::Document
  include Mongoid::Timestamps
  #TODO: remplacer par PostImage::RemoteFile
  extend Image::RemoteFile

  THUMBS_FORMAT="300x300"

  TO_KEEP_STATUS="TO_KEEP_STATUS"
  TO_SORT_STATUS="TO_SORT_STATUS"
  TO_DELETE_STATUS="TO_DELETE_STATUS"
  DELETED_STATUS="DELETED_STATUS"
  KEPT_STATUS="KEPT_STATUS"

  embedded_in :website_post

  field :scrapped_at, type: DateTime
  field :key, type: String
  field :status, type: String
  
  validates_uniqueness_of :key, :scope => :website_post

  def thumbnail_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.thumbnail_path(key, THUMBS_FORMAT)).to_s
  end

  #TODO : A supprimer
  def fullsize_url
    Facades::S3.new(IMAGE_BUCKET).url(Image.image_path(key)).to_s
  end
end