require 'rails_helper'

describe UserPost do

  describe "save" do
    it {FactoryGirl.build(:user_post).save.should == true}
  end
  
  describe "new" do
    it {UserPost.new.pages_seen.should == []}
    it {UserPost.new.images_seen_count.should == 0}
    it {UserPost.new.current_page.should == 0}
  end

  describe "has an array of pages seen" do
    it "finds visited page" do
      user_post = FactoryGirl.create(:user_post, :pages_seen => [2, 3, 6])
      user_post.reload.pages_seen.include?(3).should == true
    end
    
    it "adds a page to list of visited page" do
      user_post = FactoryGirl.create(:user_post, :pages_seen => [2, 3, 6])
      user_post.pages_seen << 7
      user_post.save
      user_post.reload.pages_seen.include?(7).should == true
    end
    
    it "adds only new page to list of visited page" do
      user_post = FactoryGirl.create(:user_post, :pages_seen => [2, 3, 6])
      user_post.add_to_set(pages_seen: 6)
      user_post.reload.pages_seen.should == [2, 3, 6]
    end
  end
end

