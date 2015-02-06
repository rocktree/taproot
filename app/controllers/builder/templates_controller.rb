class Builder::TemplatesController < BuilderController

  def index
  end

  def show
    redirect_to builder_route([current_template, current_template_fields], :index)
  end

end
