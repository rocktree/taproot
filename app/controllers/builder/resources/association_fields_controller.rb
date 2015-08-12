class Builder::Resources::AssociationFieldsController < Editor::BaseController

  def index
  end

  def new
    @current_resource_association_field = ResourceAssociationField.new
  end

  def create
    @current_resource_association_field = ResourceAssociationField.new(create_params)
    if current_resource_association_field.save
      redirect_to(
        builder_route(
          [current_resource_type, current_resource_association_field],
          :index
        ),
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
        if current_resource_association_field.update(update_params)
          redirect_to(
            builder_route(
              [current_resource_type, current_resource_association_field],
              :index
            ),
            :notice => 'Field save successfully!'
          )
        else
          render 'edit'
        end
      end
      format.json do
        current_resource_association_field.update!(position_params)
        render :nothing => true
      end
    end
  end

  def destroy
    current_resource_association_field.destroy!
    redirect_to(builder_route([rt, current_resource_association_field], :index))
  end

  def hide
    current_resource_association_field.update!(:hidden => true)
    redirect_to(builder_route([rt, current_resource_association_field], :index))
  end

  def show
    current_resource_association_field.update!(:hidden => false)
    redirect_to(builder_route([rt, current_resource_association_field], :index))
  end

  private

    def position_params
      params.require(:resource_association_field).permit(:position)
    end

    def create_params
      update_params.merge(:resource_type => current_resource_type)
    end

    def update_params
      params.require(:resource_association_field).permit(
        :title,
        :position,
        :slug,
        :label,
        :data_type,
        :options,
        :required,
        :position,
        :hidden,
        :default_value,
        :half_width
      )
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'index'
          "Resource Fields >> #{current_resource_type.title}"
        when 'edit', 'update'
          "Edit #{current_resource_association_field.title} >> #{current_resource_type.title}"
        when 'new', 'create'
          "New Resource Field >> #{current_resource_type.title}"
        end
      end
    end

    def rt
      current_resource_type
    end

end
