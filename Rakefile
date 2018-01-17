require_relative 'domain_checker'

namespace :domain_checker do
  desc 'Run the domain checked'
  task :run do
    run_domain_check
  end

  namespace :schedule do
    desc 'Schedule cron job to check domains according to the config/schedule.rb file'
    task :run_daily do
      `bundle exec whenever -i`
    end
  end

end
