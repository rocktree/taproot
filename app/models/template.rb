class Template

  def initialize(file, site)
    @file = file
    @site = site
    set_attrs
  end

  def name
    @name ||= filename.split('.').first
  end

  def filename
    @filename ||= @file.split('/').last
  end

  def attributes
    @attributes.deep_symbolize_keys
  end

  def fields
    @fields ||= TemplateFieldCollection.new(frontmatter.first['fields'])
  end

  private

    def set_attrs
      @attributes ||= frontmatter.first.except('fields')
    end

    def frontmatter
      @frontmatter ||= Frontmatter.parse(@file)
    end

    def method_missing(method, *arguments, &block)
      begin
        @attributes[method.to_s] || super
      rescue
        super
      end
    end

end
