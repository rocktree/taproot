class Builder::Templates::FieldsController < BuilderController

  def index
  end

  def new
    @current_template_field = TemplateField.new
  end

  def create
    @current_template_field = TemplateField.new(field_params)
    if current_template_field.save
      redirect_to builder_route([t, t.fields], :index), :notice => 'Field saved!'
    else
      render 'new'
    end
  end

  private

    def field_params
      params.require(:template_field).permit(
        :title, 
        :position,
        :template_group_id,
        :slug,
        :data_type,
        :options,
        :required,
        :position
      )
    end

    def t
      current_template
    end

end
