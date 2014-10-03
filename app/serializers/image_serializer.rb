class ImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :width, :height, :source_url, :hosting_url

  def id
    object.id.to_s
  end

  def url
    object.thumbnail_url
  end 
end