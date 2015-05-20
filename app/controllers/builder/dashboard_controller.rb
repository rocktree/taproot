class Builder::DashboardController < BuilderController

  def index
    if !current_user.admin? && !has_multiple_sites?
      redirect_to(builder_site_path(only_site))
    end
    @options['body_classes'] = 'dashboard'
  end

  def new
    @current_site = Site.new
  end

  def create
    @current_site = Site.new(create_params)
    if current_site.save
      if params[:site][:new_repo].to_bool
        create_sapwood_project
      end
      redirect_to(
        route([current_site], :edit, 'builder'),
        :notice => t('notices.created', :item => "Site")
      )
    else
      render('new')
    end
  end

  private

    def create_params
      params.require(:site).permit(
        :title,
        :url,
        :secondary_urls,
        :description,
        :home_page_id,
        :git_url,
        :image_croppings_attributes => [
          :id,
          :title,
          :ratio,
          :width,
          :height
        ]
      )
    end

end
