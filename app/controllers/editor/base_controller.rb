class Editor::BaseController < EditorController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :all_pages,
                :all_sites,
                :all_templates,
                :current_page,
                :current_site,
                :current_template

  before_filter :authenticate_user!
  before_filter :request_store

  def home
    if current_user.has_sites?
      site = current_site.nil? ? current_user.first_site : current_site
      redirect_to(site_editor_pages_path(site))
    else
      sign_out_and_redirect(current_user)
    end
  end

  private

    def request_store
      RequestStore.store[:topkit] = current_user
    end

    def not_found
      ActionController::RoutingError.new('Page not found.')
    end

    # ------------------------------------------ Collections

    def all_pages
      @all_pages ||= current_site.pages
    end

    def all_sites
      @all_sites ||= current_user.sites.alpha
    end

    def all_templates
      @all_templates ||= current_site.templates.all
    end

    # ------------------------------------------ Objects

    def current_page
      @current_page ||= begin
        p = params[:page_slug] || params[:slug]
        all_pages.select { |p| p.slug == p }.first
      end
    end

    def current_site
      @current_site ||= begin
        return nil unless params[:site_uid]
        all_sites.select { |s| s.uid == params[:site_uid] }.first
      end
    end

    def current_template
      @current_template ||= current_page.template
    end

end
