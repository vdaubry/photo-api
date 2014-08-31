namespace :user do
  desc "benchmark adding website to user"
  task :add_website => :environment do
    start_time = DateTime.now
    user = User.first
    begin
      Website.each do |website|
        uw = UserWebsite.new(:website_id => website.id, :name => website.name, :url => website.url)
        user.user_websites.push(uw)
      end
      #website = Website.first
      #user.user_websites.push(UserWebsite.new(:website_id => website.id, :name => website.name, :url => website.url))

      user.update_websites
    ensure
      puts "Duration = #{((DateTime.now - start_time) * 24 * 60 * 60).to_i} seconds"
      File.open("tmp/user.txt", "w") do |f|
        f.puts(user.to_json)
      end
      #User.destroy_all
    end
  end

  task :bench_create => :environment do
    begin
      user = User.create(:email => "foo@bar.com", :password => "foobar")
      website = Website.where(:name => /JB/).first
      user.user_websites = [UserWebsite.new(:website_id => website.id)]
      post = website.posts.first
      website_post = WebsitePost.new(:post_id => post.id)
      user.user_websites.first.website_posts = [website_post]


      images = post.images
      puts "images = #{images.count}"

      puts Benchmark.measure {
        pi = []
        #TODO: tester le même benchmark avec les appels réseaux vers la db : 
        # - faire varier batch_size pour modifier le nombre de get sur la base (et la taille en RAM)
        # - BUFFER_SIZE pour modifier le nombre de post sur la base (et la taille des requêtes suy le réseau)
        # en local avec ces settings => 3.9s
        BUFFER_SIZE=100
        images.limit(1000).batch_size(100).each do |image|
          pi << PostImage.new(:key => image.key)
          if pi.count >= BUFFER_SIZE
            puts "flushing buffer at #{DateTime.now}"
            website_post.post_images.push(pi)
            pi = []
          end
        end

        puts "website_post.post_images = #{website_post.post_images.count}"
      }
    ensure
      User.destroy_all
    end
  end
end