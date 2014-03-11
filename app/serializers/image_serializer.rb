class ImageSerializer < ActiveModel::Serializer
  attributes :id, :key, :width, :height, :source_url, :hosting_url

  def id
    object.id.to_s
  end
end