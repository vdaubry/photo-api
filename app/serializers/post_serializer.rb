class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :source_url

  def id
    object.id.to_s
  end
end
