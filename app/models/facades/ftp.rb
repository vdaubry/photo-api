class Facades::Ftp
  FTP_ADRESS = '84.103.194.37'

  IMAGES_PATH="/mnt/HDD/ftp/images/to_sort"
  THUMBNAILS_PATH="/mnt/HDD/ftp/images/to_sort/thumbnails/300"  
  SAVE_PATH="/mnt/HDD/ftp/backup/Pic/New"
  
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
end