class Zipfile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: String
end