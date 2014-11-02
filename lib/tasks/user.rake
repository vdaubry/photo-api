namespace :user do
  desc "benchmark adding website to user"
  task :add_website => :environment do
    start_time = DateTime.now
    user = User.where(:email => "foo@bar.com", :password => "foobar").first_or_create

    begin
      user.follow_website(Website.first)
      puts "post count = #{user.user_websites.first.website_posts.count}"
      puts "image count = #{user.user_websites.first.website_posts.inject(0) {|sum, post| sum+post.post_images.count}}"
    ensure
      puts "Duration = #{((DateTime.now - start_time) * 24 * 60 * 60).to_i} seconds"
      File.open("tmp/user_website.txt", "w") do |f|
        f.puts(user.user_websites.first.to_json)
      end
      #User.destroy_all
    end
  end

  task :bench_create => :environment do
    user = User.create(:email => "foo@bar.com", :password => "foobar")

    begin
      website = Website.where(:name => /JB/).first
      user.user_websites = [UserWebsite.new(:website_id => website.id)]
      post = website.posts.first
      website_post = WebsitePost.new(:post_id => post.id)
      user.user_websites.first.website_posts = [website_post]

      images = post.images
      puts "images = #{images.count}"

      with_buffer = false

      puts Benchmark.measure {

        if with_buffer
          pi = []
          #TODO: tester le même benchmark avec les appels réseaux vers la db : 
          # - faire varier batch_size pour modifier le nombre de get sur la base (et la taille en RAM)
          # - BUFFER_SIZE pour modifier le nombre de post sur la base (et la taille des requêtes sur le réseau)
          # en local avec ces settings => 2.6s
          # en remote avec ces settings => 6.0s
          BUFFER_SIZE=500
          images.limit(1000).batch_size(100).each do |image|
            pi << PostImage.new(:key => image.key)
            if pi.count >= BUFFER_SIZE
              puts "flushing buffer at #{DateTime.now}"
              website_post.post_images.push(pi)
              pi = []
            end
          end
        else
          # en local avec ces settings => 1.4s
          # en remote avec ces settings => 101s
          pi = images.limit(1000)
        end
        website_post.post_images.push(pi) if pi.count >= 1

        puts "website_post.post_images = #{website_post.post_images.count}"
      }
    ensure
      user.destroy
    end
  end
end