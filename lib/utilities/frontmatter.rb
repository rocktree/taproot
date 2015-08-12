require 'yaml'

class Frontmatter

  def self.parse(file)
    content = File.read(file)
    yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    if content =~ yaml_regex
      content = content.sub(yaml_regex, "")
      begin
        data = YAML.load($1)
      rescue Exception => e
        raise "YAML Exception: #{e.message}"
      end
    else
      return [{}, content]
    end
    [data, content]
  end

end
