namespace :sapwood do

  namespace :db do

    desc 'Backup database'
    task :backup => :environment do
      SapwoodDatabase.new.backup
    end

    desc 'Backup database'
    task :sync => :environment do
      SapwoodDatabase.new.sync
    end

  end

end