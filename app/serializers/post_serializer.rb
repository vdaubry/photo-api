#TODO: a supprimer

class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :status, :banished

  def id
    object.id.to_s
  end
end
