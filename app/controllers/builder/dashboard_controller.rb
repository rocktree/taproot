class Builder::DashboardController < Editor::BaseController

  before_filter :set_classes

  def index
    if !current_user.admin? && !has_multiple_sites?
      redirect_to(builder_site_path(only_site))
    end
  end

  def new
    @current_site = Site.new
  end

  def create
    @current_site = Site.new(create_params)
    if current_site.save
      SapwoodProject.new(current_site).create_site
      redirect_to(
        route([current_site, site_pages], :index, 'builder'),
        :notice => t('notices.created', :item => "Site")
      )
    else
      render('new')
    end
  end

  private

    def create_params
      params
        .require(:site)
        .permit(:title, :template_url, :url, :secondary_urls, :git_url)
    end

    def set_classes
      @options['body_classes'] = 'dashboard'
    end

end
