config_file = File.join(Rails.root,'config','sapwood.yml')
if File.exists?(config_file)
  SapwoodSetting = YAML.load_file(config_file)[Rails.env].to_ostruct
else
  raise "Can't find file: #{config_file}"
end
