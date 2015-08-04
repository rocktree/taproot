class Builder::Pages::ResourcesController < Editor::BaseController

  before_filter :verify_current_page

  def index
  end

  def new
    @current_page_resource = PageResource.new
    @url = index_route
  end

  def create
    @current_page_resource = PageResource.new(create_params)
    if current_page_resource.save
      redirect_to(
        index_route,
        :notice => "#{current_resource_type.title.singularize} saved
          successfully!"
      )
    else
      @url = index_route
      render 'new'
    end
  end

  def edit
    @url = show_route
  end

  def update
    if current_page_resource.update(update_params)
      redirect_to(
        index_route,
        :notice => "#{current_resource_type.title.singularize} save successfully!"
      )
    else
      @url = show_route
      render 'edit'
    end
  end

  def destroy
    current_page_resource.destroy
    redirect_to(
      index_route,
      :notice => "#{current_resource_type.title.singularize} deleted successfully!"
    )
  end

  private

    def index_route
      builder_site_page_resource_type_resources_path(
        current_site, current_page, current_resource_type
      )
    end

    def show_route
      builder_site_page_resource_type_resource_path(
        current_site, current_page, current_resource_type, current_page_resource
      )
    end

    def create_params
      p = params.require(:page_resource).permit(
        :resource_id
      ).merge(
        :page => current_page
      )
      unless params[:page_resource][:field_data].blank?
        p = p.merge(
          :field_data => params[:page_resource][:field_data]
        )
      end
      p
    end

    def update_params
      p = params.require(:page_resource).permit(:resource_id)
      unless params[:page_resource][:field_data].blank?
        p = p.merge(:field_data => params[:page_resource][:field_data])
      end
      p
    end

end
