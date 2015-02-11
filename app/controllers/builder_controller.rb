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

  before_filter :verify_env
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

    def verify_env
      authenticate_user!
      if !Rails.env.production? && request.path != builder_sites_path
        if(
          TaprootSetting.contributing.nil? || 
          TaprootSetting.contributing.to_bool == false
        )
          redirect_to builder_sites_path
        end
      end
    end

end
