class Editor::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include(
    # ApplicationHelper,
    # RoutingHelper,
    # UsersHelper,
    # SitesHelper,
    # TemplatesHelper,
    # ResourcesHelper,
    # PagesHelper,
    # ErrorsHelper
  )

  before_filter :authenticate_user!
  before_filter :current_site, :except => [:home]
  before_filter :request_store
  before_filter :eager_load_services

  def home
    raise all_sites.size.to_s
    # if current_user.has_sites? || admin?
    #   redirect_to(builder_dashboard_path)
    # else
    #   sign_out_and_redirect(current_user)
    # end
  end

  private

    def verify_admin
      not_found unless current_user.admin?
    end

    def request_store
      RequestStore.store[:topkit] = current_user
    end

    def eager_load_services
      @current_object = CurrentObject.new(request, params)
      @collection = Collection.new(request, params)
    end

    def method_missing(method, *arguments, &block)
      begin
        super
      rescue
        if method.to_s =~ /^current\_/
          @current_object.send(method.to_s.split('_')[1..-1].join('_'))
        elsif @collection.methods.include?(method)
          @collection.send(method.to_s)
        end
      end
    end

end
