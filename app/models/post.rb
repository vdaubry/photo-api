class Post
  TO_SORT_STATUS="TO_SORT_STATUS"
  SORTED_STATUS="SORTED_STATUS"

  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :status, type: String, default: Post::TO_SORT_STATUS
  field :pages_url, type: Array
  has_many :images
  belongs_to :scrapping
  belongs_to :website
  
  validate :unique_name_per_scrapping, :on => :create
  validates_inclusion_of :status, in: [ TO_SORT_STATUS, SORTED_STATUS ]

  scope :to_sort, -> {where(:status => TO_SORT_STATUS)}
  scope :sorted, -> {where(:status => SORTED_STATUS)}
  scope :with_page_url, ->(url) {where(:pages_url.in => [url])}

  def check_status!
    self.update_attributes(:status => Post::SORTED_STATUS) if self.images.where(:status => Image::TO_SORT_STATUS).count == 0
  end


  private 

  def unique_name_per_scrapping
    self.errors.add :name, 'must be unique' if self.scrapping.present? && Post.where(:scrapping => self.scrapping, :name => self.name).size > 0
  end

end
