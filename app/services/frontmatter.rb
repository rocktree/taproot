require 'yaml'

class Frontmatter

  def self.parse(file)
    content = File.read(file)
    yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    if content =~ yaml_regex
      content = content.sub(yaml_regex, "")
      begin
        data = YAML.load($1)
      rescue *YAML_ERRORS => e
        logger.error "YAML Exception: #{e.message}"
        return false
      end
    else
      return [{}, content]
    end
    [data, content]
  end

end
