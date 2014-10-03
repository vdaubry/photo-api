require 'aws-sdk'

module Facades
  class S3
    def initialize
      AWS.config({
      :access_key_id => ENV["AWS_ACCESS_KEY"],
      :secret_access_key => ENV["AWS_SECRET"]
      })

      s3 = AWS::S3.new 
      @bucket = s3.buckets[S3_BUCKET]
    end

    def key_path(key)
      timestamp = key.split("_").first.to_i
      folder1 = timestamp / 10000000
      folder2 = timestamp / 10000
      folder3 = timestamp / 10
      "#{folder1}/#{folder2}/#{folder3}/#{key}"
    end

    def image_path(key)
      "image/#{key_path(key)}"
    end

    def thumbnail_path(key, format)
      "thumbnail/#{format}/#{key_path(key)}"
    end

    def thumbnail_url(key, format)
      @bucket.objects[thumbnail_path(key, format)].url_for(:read, :expires => 5*60)
    end

    # def get_image(key)
    #   unless ENV['TEST']
    #     obj = @bucket.objects[key]
    #     File.open('file.txt', 'wb') do |file|
    #       obj.read do |chunk|
    #          file.write(chunk)
    #       end
    #     end
    #   end
    # end
  end
end