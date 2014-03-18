class ScrappingSerializer < ActiveModel::Serializer
  attributes :id, :date, :duration, :image_count, :success

  def id
    object.id.to_s
  end
end