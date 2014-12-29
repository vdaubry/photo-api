class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :url

  def id
    object.id.to_s
  end

  # def images_to_sort_count
  #   object.images.where(:status => Image::TO_SORT_STATUS).count
  # end

  # def latest_post_id
  #   object.latest_post_id
  # end
end
