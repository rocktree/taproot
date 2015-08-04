class Builder::Sites::SettingsController < Editor::BaseController

  include SettingsHelper

  def index
  end

  def show
    redirect_to(
      edit_builder_site_site_setting_path(current_site, current_setting)
    )
  end

  def new
    @current_setting = SiteSetting.new
  end

  def create
    @current_setting = SiteSetting.new(create_params)
    if current_setting.save
      redirect_to(
        builder_route([current_setting], :index),
        :notice => 'Setting saved successfully!'
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_setting.update(update_params)
      redirect_to(
        builder_route([current_setting], :index),
        :notice => 'Setting saved successfully!'
      )
    else
      render 'edit'
    end
  end

  def destroy
    current_setting.destroy
    redirect_to(
      builder_route([current_setting], :index),
      :notice => 'Setting deleted successfully!'
    )
  end

  private

    def create_params
      params.require(:site_setting).permit(:title, :slug, :body)
        .merge(:site => current_site)
    end

    def update_params
      params.require(:site_setting).permit(:title, :slug, :body)
    end

end
