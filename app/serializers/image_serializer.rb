class ImageSerializer < ActiveModel::Serializer
  attributes :id, :fullsize_url, :thumbnail_url, :width, :height

  def id
    object.id.to_s
  end

  def thumbnail_url
    object.thumbnail_url
  end 

  def fullsize_url
    object.fullsize_url
  end
end