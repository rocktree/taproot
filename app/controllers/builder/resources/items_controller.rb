class Builder::Resources::ItemsController < Editor::BaseController

  def index
  end

  def new
    @current_resource = Resource.new
  end

  def create
    @current_resource = Resource.new(create_params)
    if current_resource.save
      redirect_to(
        builder_route([current_resource_type, current_resource], :index),
        :notice => "#{current_resource_type.title.singularize} save successfully!"
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_resource.update(update_params)
      redirect_to(
        builder_route([current_resource_type, current_resource], :index),
        :notice => "#{current_resource_type.title.singularize} save successfully!"
      )
    else
      render 'edit'
    end
  end

  def destroy
    current_resource.destroy
    redirect_to(
      builder_route([current_resource_type, current_resource], :index),
      :notice => "#{current_resource_type.title.singularize} deleted successfully!"
    )
  end

  private

    def create_params
      p = params.require(:resource).permit(
        :title, :slug
      ).merge(:resource_type => current_resource_type)
      unless params[:resource][:field_data].blank?
        p = p.merge(
          :field_data => params[:resource][:field_data]
        )
      end
      p
    end

    def update_params
      p = params.require(:resource).permit(:title, :slug)
      unless params[:resource][:field_data].blank?
        p = p.merge(:field_data => params[:resource][:field_data])
      end
      p
    end

end
