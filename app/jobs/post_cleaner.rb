class PostCleaner
  @queue = :post_clean

  def self.perform
    post_to_clean_id = Post.to_sort.select {|post| post.images.count == 0}.map(&:id)
    Resque.logger.info "Found #{post_to_clean_id.count} posts to sort"
    Post.where(:_id.in => post_to_clean_id).update_all(:status => Post::SORTED_STATUS)
  end
end