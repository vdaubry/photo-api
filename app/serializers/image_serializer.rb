class ImageSerializer < ActiveModel::Serializer
  attributes :id, :fullsize_url, :thumbnail1X_url, :thumbnail2X_url, :width, :height, :source_url, :hosting_url

  def id
    object.id.to_s
  end

  def thumbnail1X_url
    object.thumbnail1X_url
  end
  
  def thumbnail2X_url
    object.thumbnail2X_url
  end

  def fullsize_url
    object.fullsize_url
  end
end