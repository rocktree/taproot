begin
  config_file = File.join(Rails.root,'config','topkit.yml')
  TopkitSetting = YAML.load_file(config_file)[Rails.env].to_ostruct
rescue
  raise "Can't find file: #{config_file}"
end
