namespace :taproot do

  desc 'Update Taproot repo on current branch'
  task :update => :environment do
    TaprootAction.new.update_repo
  end

  desc 'Pull repo without touching server'
  task :update_repo_only => :environment do
    TaprootAction.new.update_repo(false)
  end

  desc 'Restart server (production)'
  task :restart_server => :environment do
    TaprootAction.new.restart_server
  end

  desc 'Stop server (production)'
  task :stop_server => :environment do
    TaprootAction.new.stop_server
  end

  desc 'Start server (production)'
  task :start_server => :environment do
    TaprootAction.new.start_server
  end

  desc 'Precompile assets and reload server'
  task :reload => :environment do
    TaprootAction.new.reload
  end

  desc 'Stop sidekiq server (production)'
  task :stop_sidekiq => :environment do
    TaprootAction.new.stop_sidekiq
  end

  desc 'Start sidekiq server (production)'
  task :start_sidekiq => :environment do
    TaprootAction.new.start_sidekiq
  end

  desc 'Restart sidekiq server (production)'
  task :restart_sidekiq => :environment do
    TaprootAction.new.restart_sidekiq
  end

end
