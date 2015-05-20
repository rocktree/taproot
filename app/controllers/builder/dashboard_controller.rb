class Builder::DashboardController < BuilderController

  def index
    if !current_user.admin? && !has_multiple_sites?
      redirect_to(builder_site_path(only_site))
    end
    @options['body_classes'] = 'dashboard'
  end

end
