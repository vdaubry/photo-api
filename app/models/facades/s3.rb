require 'aws-sdk'

module Facades
  class S3
    attr_accessor :bucket
    
    def initialize(bucket)
      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY_ID"],
      :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
      })

      s3 = AWS::S3.new 
      @bucket = s3.buckets[bucket]
    end

    def url(key)
      @bucket.objects[key].url_for(:read, :expires => 5*60)
    end
  end
end