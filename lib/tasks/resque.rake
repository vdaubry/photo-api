require 'resque/tasks'

task "resque:setup" => :environment do
  
    # Open the new separate log file
    logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'w')

    # Activate file synchronization
    logfile.sync = true

    # Create a new buffered logger
    Resque.logger = ActiveSupport::Logger.new(logfile)
    Resque.logger.level = Logger::INFO
    Resque.logger.info "Resque Logger Initialized!"
  
end