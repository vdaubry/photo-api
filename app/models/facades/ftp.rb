class Facades::Ftp
  FTP_ADRESS = '84.103.194.37'

  IMAGES_PATH="/mnt/HDD/ftp/images/to_sort"
  THUMBNAILS_PATH="/mnt/HDD/ftp/images/to_sort/thumbnails/300"  
  SAVE_PATH="/mnt/HDD/ftp/backup/Pic/New"
  
  # def connect_to_ftp
  #   unless ENV["RAILS_ENV"]=="test"
  #     status = Timeout::timeout(5) do
  #       @ftp_connection = Net::SFTP.start(FTP_ADRESS, ENV['FTP_LOGIN'], :password => ENV['FTP_PASSWORD'])
  #       #@ftp_connection.passive=true
  #     end
  #   end
  # end

  # def connection
  #   connect_to_ftp if @ftp_connection.nil? or @ftp_connection.closed?
  #   @ftp_connection
  # end



  def move_files_to_keep(keys)
    Net::SFTP.start(FTP_ADRESS, ENV['FTP_LOGIN'], :password => ENV['FTP_PASSWORD']) do |sftp|
      keys.each do |key|
        path1 = "#{IMAGES_PATH}/#{key}"
        path2 = "#{SAVE_PATH}/#{key}"

        sftp.rename(path1, path2)
        sftp.remove("#{THUMBNAILS_PATH}/#{key}")
        print "."
      end
    end
  end

  def delete_files(keys)
    Net::SFTP.start(FTP_ADRESS, ENV['FTP_LOGIN'], :password => ENV['FTP_PASSWORD']) do |sftp|
      keys.each do |key|
        sftp.remove("#{IMAGES_PATH}/#{key}")
        sftp.remove("#{THUMBNAILS_PATH}/#{key}")
        print "."
      end
    end
  end

  def upload_file(image)
    unless Rails.env.test?
      img_path = "#{Image.image_path}/#{image.key}"
      thumb_path = "#{Image.thumbnail_path}/#{image.key}"
      Net::SFTP.start(FTP_ADRESS, ENV['FTP_LOGIN'], :password => ENV['FTP_PASSWORD']) do |sftp|
        sftp.upload!(img_path, "#{SAVE_PATH}/#{image.key}")
        sftp.upload!(thumb_path, "#{THUMBNAILS_PATH}/#{image.key}")
      end

      File.delete(img_path)
      File.delete(thumb_path)
    end
  end
end