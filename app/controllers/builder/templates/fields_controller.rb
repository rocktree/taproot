class Builder::Templates::FieldsController < Editor::BaseController

  before_filter :verify_current_template
  before_filter :verify_admin

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

  def edit
  end

  def update
    respond_to do |format|
      format.html do
        if current_template_field.update(field_params)
          redirect_to(
            builder_route([t, t.fields], :index),
            :notice => 'Field saved!'
          )
        else
          render 'edit'
        end
      end
      format.json do
        current_template_field.update!(field_params)
        render :nothing => true
      end
    end
  end

  def destroy
    current_template_field.destroy!
    redirect_to(builder_route([t, t.fields], :index))
  end

  def hide
    current_template_field.update!(:hidden => true)
    redirect_to(builder_route([t, t.fields], :index))
  end

  def show
    current_template_field.update!(:hidden => false)
    redirect_to(builder_route([t, t.fields], :index))
  end

  private

    def field_params
      params.require(:template_field).permit(
        :title,
        :position,
        :template_group_id,
        :slug,
        :label,
        :data_type,
        :options,
        :required,
        :position,
        :hidden,
        :default_value,
        :note,
        :half_width
      )
    end

    def t
      current_template
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'index'
          "Form Fields >> #{current_template.title}"
        when 'edit', 'update'
          "Edit #{current_template_field.title} >> #{current_template.title}"
        when 'new', 'create'
          "New Form Field >> #{current_template.title}"
        end
      end
    end

end
