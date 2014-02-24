class PostsController < ApplicationController
  before_action :set_website, only: [:destroy]
  before_action :set_post, only: [:destroy]
  respond_to :json

  def destroy
    @post.images.where(:status => Image::TO_SORT_STATUS).update_all(:status => Image::TO_DELETE_STATUS)
    @post.update_attributes(:status => Post::SORTED_STATUS)

    latest_post = @website.latest_post
    latest_post_id = latest_post.nil? ? nil : latest_post.id.to_s 
    
    render :json => {:latest_post => latest_post_id} 
  end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_post
	  @post = @website.posts.find(params[:id])
	end

  def set_website
    @website = Website.find(params[:website_id])
  end

	# Never trust parameters from the scary internet, only allow the white list through.
	def post_params
	  params.require(:post).permit(:id, :name)
	end
end