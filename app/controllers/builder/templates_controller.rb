class Builder::TemplatesController < BuilderController

  def index
  end

  def show
    redirect_to builder_route([current_template], :edit)
  end

  def edit
  end

end
