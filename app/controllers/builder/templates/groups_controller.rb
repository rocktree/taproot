class Builder::Templates::GroupsController < BuilderController

  def new
    @current_template_group = TemplateGroup.new
  end

  def create
    @current_template_group = TemplateGroup.new(group_params)
    if current_template_group.save
      redirect_to builder_route([t, t.fields], :index), :notice => 'Group saved!'
    else
      render 'new'
    end
  end

  private

    def group_params
      params.require(:template_group).permit(:title)
        .merge(:template => current_template)
    end

    def t
      current_template
    end

end
