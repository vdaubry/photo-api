module Image::RemoteFile
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

  def create_zip
    images = Image.to_keep.only(:key).map {|image| image_path(image.key)}
    Facades::SQS.new(ZIPPER_QUEUE).send(images.to_json) unless images.blank?
  end

  def listen_for_done_zip
    Facades::SQS.new(DONE_ZIPPER_QUEUE).poll do |msg|
      key = JSON.parse(msg)["zipkey"]
      Zipfile.create(:key => key)
      Image.to_keep.update_all(:status => "KEPT_STATUS")
      Image.to_delete.update_all(:status => "DELETED_STATUS")
      puts "Zip file created : #{key}"
    end
  end
end