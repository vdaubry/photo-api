namespace :zip do
  desc "Listen for done zips"
  task :listen => :environment do
    Image.listen_for_done_zip
  end
end