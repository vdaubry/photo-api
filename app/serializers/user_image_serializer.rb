class UserImageSerializer < ActiveModel::Serializer
  attributes :image_id

  def image_id
    object.image_id.to_s
  end
end

