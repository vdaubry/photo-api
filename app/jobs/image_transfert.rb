class ImageTransfert
  @queue = :image_transfert

  def self.perform
    Image.transfert
  end

end