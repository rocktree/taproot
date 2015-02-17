namespace :sapwood do

  desc 'Remove all dead symlinks'
  task :remove_dead_symlinks do
    system("find #{Rails.root} -type l -exec sh -c \"file -b {} | grep -q ^broken\" \\; -delete")
  end

end
