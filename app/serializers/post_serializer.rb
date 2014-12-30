class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :source_url, :current_page

  def id
    object.id.to_s
  end
  
  def include_current_page?
    @options[:current_page].present?
  end
  
  def current_page
    @options[:current_page]
  end
end
