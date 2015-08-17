class Template

  def initialize(name, data, site)
    fields = data.select { |k,v| k == 'fields' }['fields']
    @fields = TemplateFieldCollection.new(fields)
    @attributes = data.reject { |k,v| k == 'fields' }.merge('name' => name)
  end

  def attributes
    @attributes.deep_symbolize_keys
  end

  def fields
    @fields
  end

  private

    def method_missing(method, *arguments, &block)
      begin
        @attributes[method.to_s] || super
      rescue
        super
      end
    end

end
