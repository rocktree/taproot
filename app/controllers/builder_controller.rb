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
    ResourcesHelper,
    PagesHelper,
    ErrorsHelper
  )

  before_filter :authenticate_user!
  before_filter :verify_site, :except => [:home]
  before_filter :init_options
  before_filter :builder_html_title
  before_filter :request_store

  def home
    if has_sites? || admin?
      redirect_to(builder_dashboard_path)
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

    def verify_site
      if(
        current_site.nil? &&
        ![builder_sites_path, new_builder_site_path].include?(request.path)
      )
        not_found
      end
    end

    def verify_admin
      not_found unless current_user.admin?
    end

    def request_store
      RequestStore.store[:sapwood] = current_user
    end

end
