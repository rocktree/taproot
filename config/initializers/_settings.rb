begin
  config_file = File.join(Rails.root,'config','sapwood.yml')
  SapwoodSetting = YAML.load_file(config_file)[Rails.env].to_ostruct
rescue
  begin
    backup_config = File.join(Rails.root,'config','taproot.yml')
    SapwoodSetting = YAML.load_file(backup_config)[Rails.env].to_ostruct
  rescue
    raise "Can't find file: #{config_file}"
  end
end
