require 'aws-sdk'

module Facades
  class S3
    def initialize
      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
      })

      s3 = AWS::S3.new 
      @bucket = s3.buckets[S3_BUCKET]
    end

    def url(key)
      @bucket.objects[key].url_for(:read, :expires => 5*60)
    end
  end
end