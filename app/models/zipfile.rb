class Zipfile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: String

  def url
    Facades::S3.new(ZIP_BUCKET).url(self.key)
  end
end