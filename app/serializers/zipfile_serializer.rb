class ZipfileSerializer < ActiveModel::Serializer
  attributes :url, :key

  def url
    object.url.to_s
  end
end