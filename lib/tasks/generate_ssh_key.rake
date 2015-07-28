desc 'Generates a new key/secret pair for full access to API'
task :generate_ssh_key => :environment do
  credentials = Credential.create!(
    :key => Credential.generate_key!,
    :secret => Credential.generate_secret!,
  )
  puts "{#{credentials.key}|#{credentials.secret}}"
end
