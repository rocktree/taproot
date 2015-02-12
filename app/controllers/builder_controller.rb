class BuilderController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include(
    ApplicationHelper, 
    RoutingHelper, 
    UsersHelper, 
    SitesHelper, 
    TemplatesHelper, 
    PagesHelper
  )

  before_filter :authenticate_user!
  before_filter :init_options

  def home
    if has_sites? || admin?
      redirect_to(builder_sites_path)
    else
      sign_out_and_redirect(current_user)
    end
  end

  private

    def init_options
      @options = {
        'sidebar' => true,
        'body_classes' => ''
      }
    end

end
