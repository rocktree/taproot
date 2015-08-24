class Editor::PagesController < Editor::BaseController

  before_filter :verify_current_page, :except => [:index, :new, :create]
  before_filter :verify_xhr, :only => [:new, :create]

  def index
    render 'drafts' if params[:status] == 'draft'
  end

  def show
  end

  def new
    if params[:t]
      @current_template = all_templates.select { |t| t.name == params[:t] }[0]
      if @current_template.blank?
        # template does not exist
        render :nothing => true, :status => 500
      else
        @current_page = Page.new(:template_name => current_template.name)
        if params[:p]
          parent = current_site.webpages.find_by_slug(params[:p])
          current_page.parent_id = parent.id unless parent.nil?
        end
        render :layout => false
      end
    else
      # template is missing from the url params
      render :nothing => true, :status => 500
    end
  end

  def create
    @current_page = Page.new(create_params)
    if current_page.parent_id.present?
      parent = current_site.webpages.find_by_id(current_page.parent_id)
      current_page.parent_id = nil if parent.nil?
    end
    if current_page.save
      path = edit_site_editor_page_path(current_site, current_page)
      render :text => "tk-success:#{path}"
    else
      render 'new', :layout => false
    end
  end

  def edit
  end

  def update
    p = params[:page][:title] ? head_params : update_params
    old_slug = current_page.slug
    if current_page.update(p)
      current_page.reload
      new_slug = current_page.slug
      redirect_route.gsub!(/\/#{old_slug}/, "/#{new_slug}")
      redirect_to redirect_route,
                  :notice => t('notices.updated', :item => 'Page')
    else
      if params[:page][:title]
        redirect_to redirect_route, :alert => 'Could not save page.'
      else
        render 'edit'
      end
    end
  end

  def publish
    current_page.publish!
    redirect_to(redirect_route, :notice => 'Page published!')
  end

  def unpublish
    current_page.unpublish!
    redirect_to(redirect_route, :notice => 'Page unpublished!')
  end

  def destroy
    parent_page = current_page.parent
    current_page.destroy
    if parent_page.nil?
      path = site_editor_pages_path(current_site)
    end
    redirect_to(path, :notice => t('notices.deleted', :item => 'Page'))
  end

  def reorder
    params[:reorder][:pages].split(',').each_with_index do |slug, idx|
      page = all_pages.select { |p| p.slug == slug }.first
      page.update_columns(:position => idx)
    end
    redirect_to redirect_route, :notice => 'Order saved!'
  end

  private

    def create_params
      params.require(:page)
            .permit(:title, :template_name, :parent_id)
            .merge(:site => current_site)
    end

    def head_params
      params.require(:page).permit(:title, :slug)
    end

    def update_params
      p = params.require(:page).permit(:body)
      fd = current_page.field_data || {}
      unless params[:page][:field_data].blank?
        p = p.merge(:field_data => fd.merge(params[:page][:field_data]))
      end
      p
    end

    def verify_current_page
      not_found if current_page.nil?
    end

    def verify_xhr
      redirect_to site_editor_pages_path(current_site) unless request.xhr?
    end

end
