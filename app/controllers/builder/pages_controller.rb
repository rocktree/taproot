class Builder::PagesController < BuilderController

  before_filter :verify_current_page, :except => [:index, :new, :create]
  before_filter :verify_admin, :only => [:destroy]

  def index
    # First, we find which set of pages we should start
    # with, which depends on whether there is a search query
    # or not.
    if params[:search] && params[:search][:q]
      q = params[:search][:q]
      @pages = current_site.pages.search_content(params[:search][:q]).to_a
    else
      @pages = site_root_pages
    end
    # If we have a published param, then we're good,
    # otherwise we set it and get ready to redirect.
    if params[:published]
      if ['published','draft'].include?(params[:published])
        @pages = @pages.select { |p| p.send("#{params[:published]}?") }
      end
    else
      redirect = true
      params[:published] = 'all'
    end
    # If we have a template param, then we're good,
    # otherwise we set it and get ready to redirect.
    if params[:template]
      if params[:template] != 'all'
        @pages = @pages.select { |p| p.template.slug == params[:template] }
      end
    else
      redirect = true
      params[:template] = 'all'
    end
    # We only redirect if we're missing parameters
    if redirect
      if q.nil?
        redirect_to builder_site_pages_path(
          current_site,
          :published => params[:published],
          :template => params[:template]
        )
      else
        redirect_to builder_site_pages_path(
          current_site,
          :published => params[:published],
          :template => params[:template],
          :search => { :q => q }
        )
      end
    else
      @pages = Kaminari.paginate_array(@pages).page(params[:page]).per(15)
    end
  end

  def show
    if template_children.size > 0
      if params[:template].blank? || params[:published].blank?
        t = params[:template] || 'any'
        p = params[:published] || 'all'
        redirect_to(
          builder_site_page_path(
            current_site, current_page, :published => p, :template => t
          )
        )
      end
    else
      redirect_to builder_route([current_page], :edit)
    end
  end

  def help
  end

  def new
    redirect_to builder_site_path(current_site) unless params[:template]
    @current_template = site_templates.find_by_slug(params[:template])
    @current_page = Page.new
  end

  def create
    process_files
    @current_page = Page.new(create_params)
    if current_page.save!
      # save_files
      redirect_to(
        builder_route([current_page], :edit),
        :notice => t(
          'notices.created',
          :item => controller_name.humanize.titleize
        )
      )
    else
      render('new')
    end
  end

  def edit
    if current_template_group.nil?
      redirect_to builder_site_page_settings_path(
        current_site, current_page, current_template_groups.first
      )
    end
  end

  def move
  end

  def update
    respond_to do |format|
      format.html do
        process_files
        slug = current_page.slug
        if current_page.update(update_params)
          # save_files
          route = redirect_route.gsub(/#{slug}/, current_page.slug)
          redirect_to(route,
            :notice => t(
              'notices.updated',
              :item => controller_name.humanize.titleize
            )
          )
        else
          render('edit')
        end
      end
      format.json do
        current_page.update!(update_params)
        render :nothing => true
      end
    end
  end

  def publish
    current_page.update(:published => true)
    redirect_to(redirect_route, :notice => 'Page published!')
  end

  def unpublish
    current_page.update(:published => false)
    redirect_to(redirect_route, :notice => 'Page unpublished!')
  end

  def destroy
    current_template
    parent_page = current_page.parent
    current_page.destroy
    if parent_page.nil?
      path = builder_route([site_root_pages], :index)
    else
      path = builder_route([parent_page], :show)
    end
    current_template.save
    redirect_to(
      path,
      :notice => t('notices.updated', :item => 'Page')
    )
  end

  private

    def create_params
      @current_template = current_site.templates.find_by_id(
        params[:page][:template_id]
      )
      p = params.require(:page).permit(
        :title,
        :slug,
        :description,
        :body,
        :body_md,
        :published,
        :position,
        :parent_id,
        :show_in_nav,
        :template
      ).merge(:template => current_template, :last_editor => current_user)
      unless params[:page][:field_data].blank?
        p = p.merge(
          :field_data => params[:page][:field_data]
        )
      end
      p
    end

    def update_params
      p = params.require(:page).permit(
        :title,
        :slug,
        :description,
        :body,
        :body_md,
        :published,
        :position,
        :parent_id,
        :template_id,
        :show_in_nav,
        :template
      ).merge(:last_editor => current_user)
      unless params[:page][:field_data].blank?
        p = p.merge(
          :field_data => current_page.field_data.merge(params[:page][:field_data])
        )
      end
      p
    end

    def process_files
      @files_to_save = {}
      unless params[:page][:field_data].nil?
        keys = params[:page][:field_data].keys
        keys.each do |key|
          value = nil
          if key.starts_with?('rtfile_')
            clean_key = key.gsub(/rtfile\_/, '')
            value = params[:page][:field_data][key.to_sym]
            params[:page][:field_data][clean_key.to_sym] = value
            @files_to_save[clean_key] = value.to_i
          end
        end
      end
    end

    def redirect_route
      if params[:page]
        params[:page][:redirect_route] || builder_site_pages(current_site)
      else
        params[:redirect_route] || builder_site_pages(current_site)
      end
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'help', 'edit', 'update'
          "#{action_name.titleize} >> #{current_page.title}"
        when 'index'
          "#{current_site.title} Pages"
        when 'new', 'create'
          params[:template] ? "New #{params[:template].titleize}" : "New Page"
        else
          current_page.title
        end
      end
    end

end
