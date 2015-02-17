require 'fileutils'

namespace :sapwood do

  namespace :project do

    desc 'Create necessary symlinks for Sapwood project'
    task :symlink, [:slug] => :environment do |t, args|

      # create references
      # 
      slug = args.slug
      underscore = "#{slug.underscore}"
      service = "#{underscore}_viewer.rb"
      project_dir = "#{Rails.root}/projects/#{slug}"

      if Dir.exists?(project_dir)
        Dir.glob("#{project_dir}/**/*", File::FNM_DOTMATCH).each do |file|
          # if the file is a file
          if File.file?(file)
            # get the filename
            filename = file.split('/').last
            # if filename is a symlink reference to the directory
            if filename == '.symlink'
              # create a symlink to the whole directory
              dest = File.read(file).strip
              dest = dest.split('/')[0..-2].join('/')
              src = file.split('/')[0..-2].join('/')
              if File.exists?(dest)
                puts "File exists: #{dest}"
              else
                system("ln -s #{src} #{dest}")
                puts "Created symlink: #{src} --> #{dest}"
              end
            else
              # find any specified symlinks
              symlink = File.read(file).match(/rtsym\:(.*)[\n|\ ]/)
              unless symlink.nil?
                dest = symlink.to_s.gsub(/rtsym\:/, '').strip.split(' ').first
                if File.exists?(dest)
                  puts "File exists: #{dest}"
                else
                  system("ln -s #{file} #{dest}")
                  puts "Created symlink: #{file} --> #{dest}"
                end
              end
            end
          end
        end
      else
        puts "Couldn't find project directory: #{slug}"
      end

      # create symlinks
      # 
      # {
      #   "images"                    => "app/assets/images/viewer/#{slug}",
      #   "javascripts"               => "app/assets/javascripts/viewer/#{slug}", 
      #   "stylesheets"               => "app/assets/stylesheets/viewer/#{slug}", 
      #   "templates"                 => "app/views/viewer/#{slug}",
      #   "templates/layout.html.erb" => "app/views/layouts/viewer/#{slug}.html.erb",
      #   "utilities/services.rb"     => "app/viewer_services/#{service}", 
      #   "utilities/tasks.rake"      => "lib/tasks/viewer/#{underscore}.rake", 
      #   "utilities/config.yml"      => "config/viewer/#{underscore}.yml", 
      # }.each do |source, dest|
      #   dir = dest.split('/')[0..-2].join('/')
      #   unless Dir.exists?(dir)
      #     FileUtils.mkdir_p(dir)
      #   end
      #   if File.exists?("#{Rails.root}/#{dest}")
      #     system("rm #{Rails.root}/#{dest}")
      #   end
      #   system("ln -s #{project_dir}/#{source} #{Rails.root}/#{dest}")
      # end

    end

  end

end
