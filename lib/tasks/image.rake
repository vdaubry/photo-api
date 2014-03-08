namespace :image do

  desc "Move images to their respective folders"
  task :sort  => :environment do
    raise "Cannot sort images when calinours safety is on !!" if Image.first.key == "calinours.jpg"

    ftp = Facades::Ftp.new

    pp "Deleting #{Image.where(:status => Image::TO_DELETE_STATUS).count} images"
    keys = Image.where(:status => Image::TO_DELETE_STATUS).map(&:key)
    ftp.delete_files(keys)
    

    pp "Saving #{Image.where(:status => Image::TO_KEEP_STATUS).count} images"
    keys = Image.where(:status => Image::TO_KEEP_STATUS).map(&:key)
    ftp.move_files_to_keep(keys)

    Image.where(:status => Image::TO_KEEP_STATUS).update_all(:status => Image::KEPT_STATUS)
    Image.where(:status => Image::TO_DELETE_STATUS).update_all(:status => Image::DELETED_STATUS)
  end
end