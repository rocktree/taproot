class Editor::BaseController < EditorController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :all_blocks,
                :all_blocks_and_pages,
                :all_pages,
                :all_pages_tree,
                :all_sites,
                :all_templates,
                :current_page,
                :current_page_ancestors,
                :current_page_children,
                :current_page_tree,
                :current_site,
                :current_template,
                :draft_pages,
                :page_from_tree_node,
                :pages_from_template,
                :redirect_route

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

    # ------------------------------------------ Request

    def request_store
      RequestStore.store[:topkit] = current_user
    end

    def redirect_route
      return params[:redirect] if params[:redirect]
      return request.referrer unless request.referrer.blank?
      site_editor_pages_path(current_site)
    end

    # ------------------------------------------ Errors

    def not_found
      ActionController::RoutingError.new('Page not found.')
    end

    # ------------------------------------------ Collections

    def all_blocks_and_pages
      @all_blocks_and_pages ||= all_blocks_and_pages ||= current_site.webpages
    end

    def all_pages
      @all_pages ||= all_blocks_and_pages.select { |p| p.template.showable? }
    end

    def all_blocks
      @all_blocks ||= all_blocks_and_pages.select { |p| p.template.block? }
    end

    def all_sites
      @all_sites ||= current_user.sites.alpha
    end

    def all_templates
      @all_templates ||= current_site.templates.all
    end

    def pages_from_template(template)
      all_blocks_and_pages.select { |p| p.template_name == template.name }
    end

    # ------------------------------------------ Page Trees

    def all_pages_tree
      @all_pages_tree ||= begin
        current_site.webpages.arrange_serializable(:order => :position)
      end
    end

    def page_from_tree_node(node)
      all_pages.select { |p| p.slug == node.symbolize_keys[:slug] }.first
    end

    def current_page_tree
      @current_page_tree ||= begin
        current_page.subtree.arrange(:order => :position).values
      end
    end

    def current_page_children
      @current_page_children ||= current_page_tree.first.keys
    end

    def current_page_ancestors
      @current_page_ancestors ||= current_page.ancestors
    end

    def draft_pages
      @draft_pages ||= all_pages.reject(&:published?)
    end

    # ------------------------------------------ Objects

    def current_page
      @current_page ||= begin
        p = params[:page_slug] || params[:slug]
        all_blocks_and_pages.select { |page| page.slug == p }.first
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
