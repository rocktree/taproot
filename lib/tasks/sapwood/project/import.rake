require 'fileutils'

namespace :sapwood do

  namespace :project do

    desc 'Create an existing Sapwood project'
    task :import, [:slug] => :environment do |t, args|
      
      # setup task
      # 
      ARGV.each { |a| task a.to_sym do ; end }
      unless ARGV.size == 2
        puts "Usage: bundle exec sapwood:project:import [SLUG]"
        exit
      end

      # references >> make sure we can find the project
      # 
      slug = ARGV[1]
      site = Site.find_by_slug(slug)
      if site.nil?
        puts "Couldn't find project with slug: #{slug}"
        exit
      elsif site.git_url.blank?
        puts "Project does not have a git url."
        exit
      end

      # make sure we have the projects directory
      # 
      projects_dir = "#{Rails.root}/projects"
      unless Dir.exists?(projects_dir)
        FileUtils.mkdir(projects_dir)
      end

      # clone the repository
      # 
      git_url = "#{PRIVATE['git']['protocol']}://#{PRIVATE['git']['username']}"
      git_url += ":#{PRIVATE['git']['password']}@#{PRIVATE['git']['url']}" 
      git_url += "/#{site.git_url}.git"
      system("cd #{projects_dir}; git clone #{git_url} #{slug}")

      # symlink the dinkuses
      # 
      Rake::Task["sapwood:project:symlink"].invoke(slug)

    end

  end

end
