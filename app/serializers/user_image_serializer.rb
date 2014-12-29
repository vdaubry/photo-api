class UserImageSerializer < ActiveModel::Serializer
  attributes :image_id

  def image_id
    object.image.id.to_s
  end
end

