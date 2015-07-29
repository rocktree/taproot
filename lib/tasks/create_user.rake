desc 'Create a new user and return their API key'
task :create_user => :environment do
  ARGV.each { |a| task a.to_sym do ; end }
  if ARGV.size < 4
    puts "Usage: bundle exec rake create_user [NAME] [EMAIL] [PASSWORD] [ADMIN?]"
    exit
  end
  name      = ARGV[1].to_s
  email     = ARGV[2].to_s
  password  = ARGV[3].to_s
  admin     = ARGV[4].to_bool || false
  user = User.create!(
    :email => email,
    :password => password,
    :password_confirmation => password,
    :admin => admin,
  )
  msg  = "New user created!\n"
  msg += "Name: #{user.name}\n"
  msg += "Email: #{user.email}\n"
  msg += "API Key: #{user.api_key}\n"
  puts msg
end
