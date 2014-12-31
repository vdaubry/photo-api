class UserPost
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :post, index: true
  belongs_to :website, index: true
  belongs_to :user
  
  field :pages_seen, type: Array, default: []
  field :images_seen_count, type: Integer, default: 0
  field :current_page, type: Integer, default: 0
  
  def self.getUserPost(user, post)
    user_post=user.user_posts.where(:post_id => post.id).first
    
    if user_post.nil?
      user_post= UserPost.new(:post => post, :website => post.website, :current_page => 1)
      user.user_posts.push(user_post)
    end
    user_post
  end
  
  def self.setCurrentPage(user, post, page)
    user_post=self.getUserPost(user, post)
    user_post.update_attributes(:current_page => page)
    user_post
  end
  
  def self.getCurrentPage(user, post)
    user_post=self.getUserPost(user, post)
    user_post.current_page
  end
end