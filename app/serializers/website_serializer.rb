class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :last_scrapping_date, :images_to_sort_count, :latest_post_id

  def id
    object.id.to_s
  end

  def last_scrapping_date
    if object.scrappings.blank?
      "-"
    else
      object.scrappings.desc(:date).limit(1).first.date.strftime("%Y-%m-%d")
    end
  end

  def images_to_sort_count
    object.images.where(:status => Image::TO_SORT_STATUS).count
  end

  def latest_post_id
    lp = object.latest_post
    lp.nil? ? nil : lp._id.to_i
  end

end
