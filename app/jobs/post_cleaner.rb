class PostCleaner
  @queue = :post_clean

  def self.perform
    puts "start cleaning posts"
    post_to_clean_id = Post.to_sort.select {|post| post.images.to_sort.count == 0}.map(&:id)
    Resque.logger.info "Found #{post_to_clean_id.count} posts to sort"
    Post.where(:_id.in => post_to_clean_id).update_all(:status => Post::SORTED_STATUS)
    puts "finished cleaning posts"
  end
end