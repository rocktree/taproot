require 'fileutils'

namespace :sapwood do

  namespace :project do

    desc "Remove a Sapwood project and its symlinks (doesn't delete project)"
    task :remove, [:slug] => :environment do |t, args|

      # create references
      # 
      slug = args.slug
      if slug.nil?
        puts "Usage: bundle exec sapwood:project:remove[SLUG]"
        exit
      end
      underscore = "#{slug.underscore}"
      service = "#{underscore}_viewer.rb"
      project_dir = "#{Rails.root}/projects/#{slug}"

      # remove project files
      # 
      if Dir.exists?(project_dir)
        FileUtils.rm_r(project_dir)
        puts "Removed project directory: #{project_dir}"
      else
        puts "Couldn't find project directory"
      end

      # remove dead symlinks
      # 
      system("find #{Rails.root} -type l -exec sh -c \"file -b {} | grep -q ^broken\" \\; -delete")
      puts "Removed dead symlinks"

    end

  end

end
