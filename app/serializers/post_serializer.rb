class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :pages_url

  def id
    object.id.to_s
  end
end
