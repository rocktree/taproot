class TemplateFieldCollection

  def initialize(collection)
    create_fields(collection)
  end

  def all
    @fields
  end

  def find(field)
    @fields.select { |f| f.name == field }.first
  end

  private

    def create_fields(collection)
      @fields ||= begin
        fields = []
        collection.each do |field, attrs|
          fields << TemplateField.new(attrs.merge(:name => field))
        end
        fields
      end
    end

end
