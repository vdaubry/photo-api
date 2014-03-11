class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :status

  def id
    object.id.to_s
  end
end
