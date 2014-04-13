# encoding: utf-8
namespace :migration do
  desc "Run migration process"
  task :run => :environment do
    puts "==> Before migration"
    Rake::Task["migration:before_migration"].invoke
    puts "== >After migration"
    Rake::Task["migration:after_migration"].invoke
  end

  desc "Reprise des données avant migration"
  task :before_migration => :environment do
    #method_to_run
  end

  desc "Reprise des données après migration"
  task :after_migration => :environment do
    #method_to_run
  end

  def create_forum4
    Rails.logger.info "Start running : #{__method__}"

    Rails.logger.info "End running : #{__method__}"
  end
end
