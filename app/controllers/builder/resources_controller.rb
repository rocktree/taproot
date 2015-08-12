class Builder::ResourcesController < Editor::BaseController

  before_filter :verify_current_resource_type, :except => [:index, :new, :create]

  def index
  end

  def show
    redirect_to builder_route([current_resource_type], :edit)
  end

  def new
    @current_resource_type = ResourceType.new
  end

  def create
    @current_resource_type = ResourceType.new(create_params)
    if current_resource_type.save
      redirect_to(
        builder_route([current_resource_type], :edit),
        :notice => 'Resource type created! Now add some resources or fields.'
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_resource_type.update(update_params)
      redirect_to(
        builder_route([current_resource_type], :edit),
        :notice => 'Resource type saved!.'
      )
    else
      render 'edit'
    end
  end

  def destroy
    current_resource_type.destroy
    redirect_to(
      builder_route([current_resource_type], :index),
      :notice => 'Resource type deleted!.'
    )
  end

  private

    def create_params
      params.require(:resource_type).permit(
        :title,
        :slug,
        :order_method,
        :order_direction,
        :has_show_view
      ).merge(:site => current_site, :last_editor => current_user)
    end

    def update_params
      params.require(:resource_type).permit(
        :title,
        :slug,
        :order_method,
        :order_direction,
        :has_show_view
      ).merge(:last_editor => current_user)
    end

    def redirect_route
      params[:resource_type][:redirect_route]
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'edit', 'update'
          "Edit >> #{current_resource_type.title}"
        when 'show'
          "Help >> #{current_resource_type.title}"
        when 'index'
          "#{current_site.title} Resource Types"
        when 'new', 'create'
          "New Resource Type"
        end
      end
    end

end
