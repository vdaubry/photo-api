require 'resque/tasks'
#require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
    # Resque.before_fork = Proc.new { 
    #   # Open the new separate log file
    #   logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'a')

    #   # Activate file synchronization
    #   logfile.sync = true

    #   # Create a new buffered logger
    #   Resque.logger = ActiveSupport::Logger.new(logfile)
    #   Resque.logger.level = Logger::INFO
    #   Resque.logger.info "Resque Logger Initialized!"
    # }

    Resque.logger = Logger.new("#{Rails.root}/log/resque.log")
    Resque.logger.level = Logger::INFO

    #set recurring jobss
    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
end