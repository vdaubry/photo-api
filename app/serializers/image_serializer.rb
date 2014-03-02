class ImageSerializer < ActiveModel::Serializer
  attributes :id, :key, :width, :height, :source_url

  def id
    object.id.to_s
  end
end