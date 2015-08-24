class TemplateField

  def initialize(attrs)
    set_attrs(attrs)
  end

  def attributes
    @attributes.symbolize_keys
  end

  def required
    attributes[:required] ? attributes[:required].to_bool : false
  end

  def label
    attributes[:label] ? attributes[:label] : attributes[:name].titleize
  end

  private

    def set_attrs(attrs)
      @attributes ||= attrs.stringify_keys
    end

    def method_missing(method, *arguments, &block)
      begin
        @attributes[method.to_s] || super
      rescue
        super
      end
    end

end
