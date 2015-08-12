class Builder::Forms::FieldsController < Editor::BaseController

  include FormsHelper

  def index
  end

  def new
    @current_form_field = FormField.new
  end

  def create
    @current_form_field = FormField.new(create_params)
    if current_form_field.save
      redirect_to(
        builder_route([current_form, current_form_field], :index),
        :notice => 'Field save successfully!'
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      format.html do
        if current_form_field.update(update_params)
          redirect_to(
            builder_route([current_form, current_form_field], :index),
            :notice => 'Field save successfully!'
          )
        else
          render 'edit'
        end
      end
      format.json do
        current_form_field.update!(position_params)
        render :nothing => true
      end
    end
  end

  def destroy
    current_form_field.destroy
    redirect_to(
      builder_route([current_form, current_form_field], :index),
      :notice => 'Field deleted successfully!'
    )
  end

  private

    def position_params
      params.require(:form_field).permit(:position)
    end

    def create_params
      update_params.merge(:form => current_form)
    end

    def update_params
      params.require(:form_field).permit(
        :title,
        :data_type,
        :options,
        :required,
        :position,
        :slug,
        :label,
        :placeholder,
        :default_value,
        :show_label,
        :hidden
      )
    end

end
