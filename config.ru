# This file is used by Rack-based servers to start the application.

# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (100*(1024**2)), (125*(1024**2)), check_cycle = 16, verbose = true

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
