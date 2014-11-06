#TODO: A supprimer

class ImageSerializer < ActiveModel::Serializer
  attributes :id, :fullsize_url, :thumbnail_url, :width, :height, :source_url, :hosting_url

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