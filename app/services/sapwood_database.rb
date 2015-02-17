require 'yaml'
require 'fileutils'

class SapwoodDatabase

  def initialize
  end

  def backup
    cmd =  "mysqldump -u #{config[:user]} --password='#{config[:password]}' "
    cmd += "#{config[:name]} > #{backup_file}"
    system(cmd)
    if File.exists?(backup_file_copy)
      system("rm #{backup_file_copy}")
    end
    system("cp #{backup_file} #{backup_file_copy}")
  end

  def sync
    system("bundle exec rake dbsync:clone")
  end

  def backup_file_copy
    "#{backup_dir}/#{config[:name]}.sql"
  end

  private

    def config
      @config ||= begin
        db_info = YAML.load_file(config_file)
        {
          :adapter  => db_info[Rails.env]['adapter'],
          :name     => db_info[Rails.env]['database'],
          :user     => db_info[Rails.env]['username'],
          :password => db_info[Rails.env]['password']
        }
      end
    end

    def config_file
      file = "#{Rails.root}/config/database.yml"
      unless File.exists?(file)
        raise "Database config not found."
      end
      file
    end

    def timestamp
      @timestamp ||= Time.now.to_i
    end

    def backup_dir
      dir = "#{Rails.root}/db/backups"
      unless Dir.exists?(dir)
        FileUtils.mkdir(dir)
      end
      dir
    end

    def backup_file
      "#{backup_dir}/#{config[:name]}_#{timestamp}.sql"
    end

end
