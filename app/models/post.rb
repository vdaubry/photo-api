class Post
  TO_SORT_STATUS="TO_SORT_STATUS"
  SORTED_STATUS="SORTED_STATUS"

  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :status, type: String, default: Post::TO_SORT_STATUS
  field :pages_url, type: Array
  field :banished, type: Boolean
  has_many :images
  belongs_to :scrapping
  belongs_to :website
  index({website_id: 1, status: 1, updated_at: 1})
  
  validates_inclusion_of :status, in: [ TO_SORT_STATUS, SORTED_STATUS ]

  after_save :delete_banished_images

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :sorted, -> {where(:status => SORTED_STATUS)}
  scope :with_page_url, ->(url) {where(:pages_url.in => [url])}

  def check_status!
    update_attributes(:status => Post::SORTED_STATUS) if images.where(:status => Image::TO_SORT_STATUS).count == 0
  end

  def update_post_status
    update_attribute(:status, Post::TO_SORT_STATUS) if status == Post::SORTED_STATUS
  end

  private 

  #TODO : remplacer par une méthode banish => set tle status du post à sorted, toutes les images à to_delete et banished = true
  def delete_banished_images
    self.images.update_all(:status => Image::TO_DELETE_STATUS) if self.banished_changed? && self.banished
  end

end
