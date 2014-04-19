class Facades::Ftp
  def move_files_to_keep(keys)
    unless Rails.env.test?
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
  end

  def delete_files(keys)
    unless Rails.env.test?
      Net::SFTP.start(FTP_ADRESS, ENV['FTP_LOGIN'], :password => ENV['FTP_PASSWORD']) do |sftp|
        keys.each do |key|
          sftp.remove("#{IMAGES_PATH}/#{key}")
          sftp.remove("#{THUMBNAILS_PATH}/#{key}")
          print "."
        end
      end
    end
  end
end