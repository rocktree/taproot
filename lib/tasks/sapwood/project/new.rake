require 'fileutils'

namespace :sapwood do

  namespace :project do

    desc 'Create a new Sapwood project'
    task :new => :environment do

      # setup task and ensure we have our arguments
      # 
      ARGV.each { |a| task a.to_sym do ; end }
      unless ARGV.size == 3
        puts "Usage: bundle exec rake sapwood:project:new [NAME] [REPO_URL]"
        exit
      end

      # create our site
      # 
      site = Site.create!(
        :title => ARGV[1],
        :git_url => ARGV[2]
      )

      # create site files
      # 
      project_dir = "#{Rails.root}/projects/#{site.slug}"
      [
        'images', 
        'javascripts', 
        'services', 
        'stylesheets', 
        'tasks', 
        'templates'
      ].each do |dir|
        FileUtils.mkdir_p("#{project_dir}/#{dir}")
        FileUtils.touch("#{project_dir}/#{dir}/.keep")
      end

      # create specific files where we only get one per directory
      # 
      FileUtils.rm("#{project_dir}/templates/.keep")
      FileUtils.touch("#{project_dir}/templates/layout.html.erb")
      FileUtils.rm("#{project_dir}/tasks/.keep")
      FileUtils.touch("#{project_dir}/tasks/#{site.slug.underscore}.rake")
      FileUtils.rm("#{project_dir}/services/.keep")
      FileUtils.touch("#{project_dir}/services/#{site.slug.underscore}_viewer.rb")

      # initialize git repository
      # 
      git_url = "#{PRIVATE['git']['protocol']}://#{PRIVATE['git']['username']}"
      git_url += ":#{PRIVATE['git']['password']}@#{PRIVATE['git']['url']}" 
      git_url += "/#{site.git_url}.git"
      system("cd #{project_dir}; git init")
      system("cd #{project_dir}; git add .")
      system("cd #{project_dir}; git commit -m 'init commit'")
      system("cd #{project_dir}; git remote add origin #{git_url}")
      system("cd #{project_dir}; git push origin master")

      # create symlinks to project
      # 
      Rake::Task["sapwood:project:symlink"].invoke(site.slug)

    end

  end

end
