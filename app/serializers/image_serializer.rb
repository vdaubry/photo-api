class ImageSerializer < ActiveModel::Serializer
  attributes :id, :key, :width, :height

  def id
    object.id.to_s
  end
end