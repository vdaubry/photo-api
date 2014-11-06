class UserWebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :latest_post_id

  def id
    object.id.to_s
  end
end
