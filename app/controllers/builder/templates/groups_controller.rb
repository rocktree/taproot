class Builder::Templates::GroupsController < Editor::BaseController

  before_filter :verify_current_template

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

  def edit
  end

  def update
    respond_to do |format|
      format.html do
        if current_template_group.update(group_params)
          redirect_to builder_route([t, t.fields], :index), :notice => 'Group saved!'
        else
          render 'edit'
        end
      end
      format.json do
        current_template_group.update!(group_params)
        render :nothing => true
      end
    end
  end

  def destroy
    current_template_group.destroy!
    redirect_to builder_route([t, t.fields], :index), :notice => 'Group deleted!'
  end

  private

    def group_params
      params.require(:template_group).permit(:title, :position)
        .merge(:template => current_template)
    end

    def t
      current_template
    end

end
