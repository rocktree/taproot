class Builder::TemplatesController < BuilderController

  def index
  end

  def show
    redirect_to builder_route([current_template], :edit)
  end

  def edit
    render request.path.split('/').last
  end

  def update
    if current_template.update(update_params)
      redirect_to(redirect_route, :notice => 'Template saved!')
    else
      params[:redirect_route] = redirect_route
      render redirect_route.split('/').last
    end
  end

  private

    def update_params
      params.require(:template).permit(
        # Template Settings
        :title, :description
      )
    end

    def redirect_route
      params[:template][:redirect_route]
    end

end
