class ImageSerializer < ActiveModel::Serializer
  attributes :id, :key

  def id
    object.id.to_s
  end
end